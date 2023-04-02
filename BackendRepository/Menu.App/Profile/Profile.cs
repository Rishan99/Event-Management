using Menu.Data.Entities;
using Menu.Data.DTOS;
using Microsoft.AspNetCore.Identity;


namespace Menu.App.Profile
{
    public class Profile : AutoMapper.Profile
    {

    }

    public class PromoCodeProfile : Profile
    {
        public PromoCodeProfile()
        {
            CreateMap<EventInsertDto, Event>();
            CreateMap<EventUpdateDto, Event>();
            CreateMap<Event, EventSelectDto>();
            // CreateMap<PromoCode, PromoCodeSelectDto>();
            // CreateMap<RecurringPromoCodeDto, RecurringPromoCode>();
            // CreateMap<RecurringPromoCodeDto, RecurringPromoCode>().ReverseMap();
        }
    }

}

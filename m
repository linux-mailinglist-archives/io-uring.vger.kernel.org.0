Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA768217034
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 17:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgGGPPr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 11:15:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34282 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgGGPOI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 11:14:08 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200707151405epoutp04470717e8d8e4f76ad7726112ba19efca~fgTI00jTA1564215642epoutp04e
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 15:14:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200707151405epoutp04470717e8d8e4f76ad7726112ba19efca~fgTI00jTA1564215642epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594134845;
        bh=CozfpjjODVO0B3Tmqb6GxjDGwaIqxT2A79vtpOE55/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jtWK5HdkkyW9uGNJ3MBDrFI5hlpbUDZBwtVyjGzOI2H+zJDvTVW/WF3dJMOaHx2pL
         4zWstYRXxXZiTIVfJxgLvjndKPZJ/p9+1w60MXcs3AjH7To3S1Hg/cDyxp78iZ3Tjb
         p47uafSQx/+uHxhpol70WsnkL+e6+j/A/erb2IAE=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200707151404epcas5p35d9d0727ce1c34139f01b8e11465a6a2~fgTHj3vfQ0715007150epcas5p3o;
        Tue,  7 Jul 2020 15:14:04 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.5D.09475.C31940F5; Wed,  8 Jul 2020 00:14:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200707151403epcas5p40471fc85d71d08bc1faeb148b5c629ee~fgTGvfoIU1143811438epcas5p4P;
        Tue,  7 Jul 2020 15:14:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200707151403epsmtrp121320ea4b0f7c6303b75d6efd0535ba9~fgTGujOCo1286512865epsmtrp1r;
        Tue,  7 Jul 2020 15:14:03 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-d4-5f04913c13fb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.3E.08303.B31940F5; Wed,  8 Jul 2020 00:14:03 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200707151401epsmtip229d304e31cbfa2693021b85ecacabd6f~fgTEi7yBT3255432554epsmtip2c;
        Tue,  7 Jul 2020 15:14:01 +0000 (GMT)
Date:   Tue, 7 Jul 2020 20:41:05 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200707151105.GA23395@test-zns>
MIME-Version: 1.0
In-Reply-To: <20200706143208.GA25523@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7bCmhq7NRJZ4g+nX+C3mrNrGaLH6bj+b
        Rde/LSwWre3fmCxOT1jEZPGu9RyLxeM7n9ktpkxrYrTYe0vbYs/ekywWl3fNYbNYsf0Ii8W2
        3/OZLV7/OMlmcf7vcVaL3z/msDkIeOycdZfdY/MKLY/LZ0s9Nn2axO7RffUHo0ffllWMHp83
        yXm0H+hm8tj05C1TAGcUl01Kak5mWWqRvl0CV8avD0oFJxQrvjxqZmtgfCHVxcjJISFgIvF1
        6gamLkYuDiGB3YwSj5f9YoZwPjFKHJv8jAXC+cwocW/pfFaYlllL57JDJHYxSnxt/sII4Txj
        lDj76jwzSBWLgIrEhDfv2LoYOTjYBDQlLkwuBTFFBDQk3mwxAilnFljJLDGj5Q0LSLmwgKPE
        550nGUFqeAV0Jd7drAQJ8woISpyc+QSshFPASuLg405GEFtUQFniwLbjYGdLCNzhkHhyeg0z
        xHEuEhfe9TBB2MISr45vYYewpSRe9rdB2cUSv+4cZYZo7mCUuN4wkwUiYS9xcc9fsGZmgQyJ
        FSv/sELYfBK9v58wgRwnIcAr0dEmBFGuKHFv0lNooIhLPJyxBMr2kDjWfAFsjJDAL2aJh3e8
        JjDKzULyzywkGyBsK4nOD01ANgeQLS2x/B8HhKkpsX6X/gJG1lWMkqkFxbnpqcWmBcZ5qeV6
        xYm5xaV56XrJ+bmbGMGJTst7B+OjBx/0DjEycTAeYpTgYFYS4e3VZowX4k1JrKxKLcqPLyrN
        SS0+xCjNwaIkzqv040yckEB6YklqdmpqQWoRTJaJg1OqgSm+yfiK754f5wt39vzZmRz2c5nZ
        9Y0nHvGZGP5dYeKyRbas1OaO5MbikHRR4y0Xj/+67sbSea+muvGBbtOx/BnhCXXm3Yycvx1f
        XvAoPt+5Mvre2cnpXk6nH95nyngbe0vUomfT9toFO+5aROtnKJ4y8op+vOFoopJWy4uEyaU8
        nzmXK3OX9hxJ2Mdr/Cq25NI+kdKNu9eufx41Q997kY7y2YxPUZcitCI1nN3m3m+w6N5vM/HY
        uqPTJifIBWZF/kixuLntletHk4oLnre63/4xT19cdGKGyarbfz7PzvlZYBS6cC8Pz7a3zwv3
        asizi9QIRrnUVm5qYvn+jXmJyde1N7eqfWhjsbjFOONLNJcSS3FGoqEWc1FxIgDBCUVh4wMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWy7bCSvK71RJZ4gy3NkhZzVm1jtFh9t5/N
        ouvfFhaL1vZvTBanJyxisnjXeo7F4vGdz+wWU6Y1MVrsvaVtsWfvSRaLy7vmsFms2H6ExWLb
        7/nMFq9/nGSzOP/3OKvF7x9z2BwEPHbOusvusXmFlsfls6Uemz5NYvfovvqD0aNvyypGj8+b
        5DzaD3QzeWx68pYpgDOKyyYlNSezLLVI3y6BK2PplcOsBb/kKn4du8HSwLhFoouRk0NCwERi
        1tK57CC2kMAORomTF1kh4uISzdd+sEPYwhIr/z0HsrmAap4wSuzb1sEIkmARUJGY8OYdWxcj
        BwebgKbEhcmlIKaIgIbEmy1GIOXMAmuZJc7+n8YMUi4s4CjxeedJRpAaXgFdiXc3KyFG/mKW
        WHfvB9hIXgFBiZMzn7CA2MwCZhLzNj9kBqlnFpCWWP6PAyTMKWAlcfBxJ1i5qICyxIFtx5km
        MArOQtI9C0n3LITuBYzMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgmNPS2sH455V
        H/QOMTJxMB5ilOBgVhLh7dVmjBfiTUmsrEotyo8vKs1JLT7EKM3BoiTO+3XWwjghgfTEktTs
        1NSC1CKYLBMHp1QD0yKdR8wfrNdKZ37daCfd/86+QTa5tzZs8+e250FRvjm1SdPcj22QuSNy
        fMtzFoUurvVn++Z37vfbeerCS8HQc79f36gI7HaMeMOmU7z19yGF7zUhwam/knf/vhN7JEEk
        KvkiQ8JE5W1sZ+dOnngz2mV6wooE3pMluWYFqr3s8rtlFswJbQpqOCsnMjE06MP9ifkxXRfn
        +ddUTOfc6ZLxVvbAEpNl8wXXFC3Pi+c05nPcU2Xll2bley+3Wm3B0W+7fj5acn3dFbWHPs+W
        70moOX6iMq139onn61+y/yv5l3wvyypxa8jqg7MLXvN9mXbZ8fSpP/yTPOKVVHxe7CiO5tpo
        1pMg3+TDsmyxwM3jz5VYijMSDbWYi4oTAf1AtowsAwAA
X-CMS-MailID: 20200707151403epcas5p40471fc85d71d08bc1faeb148b5c629ee
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----mE6RfbMtbYdcyZmGWslR4GSM.zWZsq_P24FjfoMtl_HTY3xR=_e3042_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
        <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
        <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
        <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
        <20200705210947.GW25523@casper.infradead.org>
        <239ee322-9c38-c838-a5b2-216787ad2197@kernel.dk>
        <20200706141002.GZ25523@casper.infradead.org>
        <4a9bf73e-f3ee-4f06-7fad-b8f8861b0bc1@kernel.dk>
        <20200706143208.GA25523@casper.infradead.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------mE6RfbMtbYdcyZmGWslR4GSM.zWZsq_P24FjfoMtl_HTY3xR=_e3042_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, Jul 06, 2020 at 03:32:08PM +0100, Matthew Wilcox wrote:
>On Mon, Jul 06, 2020 at 08:27:17AM -0600, Jens Axboe wrote:
>> On 7/6/20 8:10 AM, Matthew Wilcox wrote:
>> > On Sun, Jul 05, 2020 at 03:12:50PM -0600, Jens Axboe wrote:
>> >> On 7/5/20 3:09 PM, Matthew Wilcox wrote:
>> >>> On Sun, Jul 05, 2020 at 03:00:47PM -0600, Jens Axboe wrote:
>> >>>> On 7/5/20 12:47 PM, Kanchan Joshi wrote:
>> >>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>> >>>>>
>> >>>>> For zone-append, block-layer will return zone-relative offset via ret2
>> >>>>> of ki_complete interface. Make changes to collect it, and send to
>> >>>>> user-space using cqe->flags.
>> >
>> >>> I'm surprised you aren't more upset by the abuse of cqe->flags for the
>> >>> address.

Documentation (https://kernel.dk/io_uring.pdf) mentioned cqe->flags can carry
the metadata for the operation. I wonder if this should be called abuse.

>> >> Yeah, it's not great either, but we have less leeway there in terms of
>> >> how much space is available to pass back extra data.
>> >>
>> >>> What do you think to my idea of interpreting the user_data as being a
>> >>> pointer to somewhere to store the address?  Obviously other things
>> >>> can be stored after the address in the user_data.
>> >>
>> >> I don't like that at all, as all other commands just pass user_data
>> >> through. This means the application would have to treat this very
>> >> differently, and potentially not have a way to store any data for
>> >> locating the original command on the user side.
>> >
>> > I think you misunderstood me.  You seem to have thought I meant
>> > "use the user_data field to return the address" when I actually meant
>> > "interpret the user_data field as a pointer to where userspace
>> > wants the address stored".
>>
>> It's still somewhat weird to have user_data have special meaning, you're
>> now having the kernel interpret it while every other command it's just
>> an opaque that is passed through.
>>
>> But it could of course work, and the app could embed the necessary
>> u32/u64 in some other structure that's persistent across IO. If it
>> doesn't have that, then it'd need to now have one allocated and freed
>> across the lifetime of the IO.
>>
>> If we're going that route, it'd be better to define the write such that
>> you're passing in the necessary information upfront. In syscall terms,
>> then that'd be something ala:
>>
>> ssize_t my_append_write(int fd, const struct iovec *iov, int iovcnt,
>> 			off_t *offset, int flags);
>>
>> where *offset is copied out when the write completes. That removes the
>> need to abuse user_data, with just providing the storage pointer for the
>> offset upfront.
>
>That works for me!  In io_uring terms, would you like to see that done
>as adding:
>
>        union {
>                __u64   off;    /* offset into file */
>+		__u64   *offp;	/* appending writes */
>                __u64   addr2;
>        };
But there are peformance implications of this approach?
If I got it right, the workflow is: 
- Application allocates 64bit of space, writes "off" into it and pass it
  in the sqe->addr2
- Kernel first reads sqe->addr2, reads the value to know the intended
  write-location, and stores the address somewhere (?) to be used during
  completion. Storing this address seems tricky as this may add one more
  cacheline (in io_kiocb->rw)?
- During completion cqe res/flags are written as before, but extra step
  to copy the append-completion-result into that user-space address.

Extra steps are due to the pointer indirection.
And it seems application needs to be careful about managing this 64bit of
space for a cluster of writes, especially if it wants to reuse the sqe
before the completion.
New one can handle 64bit result cleanly, but seems slower than current
one.
It will be good to have the tradeoff cleared before we take things to V4.



------mE6RfbMtbYdcyZmGWslR4GSM.zWZsq_P24FjfoMtl_HTY3xR=_e3042_
Content-Type: text/plain; charset="utf-8"


------mE6RfbMtbYdcyZmGWslR4GSM.zWZsq_P24FjfoMtl_HTY3xR=_e3042_--

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 610F714CC83
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 15:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgA2Oe0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 09:34:26 -0500
Received: from mail-lf1-f49.google.com ([209.85.167.49]:43642 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgA2OeZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 09:34:25 -0500
Received: by mail-lf1-f49.google.com with SMTP id 9so12013780lfq.10;
        Wed, 29 Jan 2020 06:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dqjs3MSryJQ2/G+YDTPrCLSOlbtWyQ155CnzyE2MZAY=;
        b=bKyaTHP5K5jrgKdsp7LLDH9jGaUhbmgdRF5EStAZWoG5JCiuKk4Nh5YNQkOs0bG5P0
         xKlJLisXUysF5fhDLoYCUI06PtSA9D4Qz9JzoLbklLq7/Ge8kiXv6WHI4JR8KyPkVRgX
         AASGJ23YBLH1rffGXm3BUOErwVYJTshPPimJbsyTMj1KCiYWbu67OsGpc1vb/yns64IQ
         XVwA0VTeqbz9BjEslDVoJEuqFnAqMiUb0Ut5Rpokvr7XFpoAwNb47Iv2D41PZcI+fvO/
         GA6L/horcup4m1680IuJKBefktPXmUb5RvOSVrrWFL31swLh1VPXDigh05S2qKYDmLvK
         c8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dqjs3MSryJQ2/G+YDTPrCLSOlbtWyQ155CnzyE2MZAY=;
        b=OnjXvr2R3JY3VxQ00+7CjC4SOeFDOwegJska0UN5ahD0CrZBFAZO51xHTSfdM9PXfY
         i3N0b29RQGOWOexgCYe1eDPDcKnuhEyOXIMSugWzOoGXIESnT9jxSW9mIuH4wRA7z20w
         iLZil6iMCRNb8rwxGm3Fh6gaD4CNm0PbgzXsp9p/g6GdJkqPP+qV8i47i+C7Wlb3d+MB
         Rvfx0yF39fcdBn2q52uKCxgAj41GmIm8wIQSnHXpdHClJCLNFeTv6Emhr/tiYIe5fPiK
         cPTSLf6pZo1BcvWr39SLnVbdNMwpZKo4ahAAQvnscH3dvhTIXxDghHckGHY7fdFhBnqQ
         UM/w==
X-Gm-Message-State: APjAAAWJbOOEEt6yYwZ1m2qYWS25Oz9tVat/W4Vqa5vor9Yw03vec1pe
        BI/O8Hbpc4WvE2tvUHMqLQqdRLPLeuc=
X-Google-Smtp-Source: APXvYqxOjB3FHd6P4jFukao9ORSnX799m625sGeI0zqFjMZUEqvAH3IjVlaNuUTzA1ox4JuVQrifTw==
X-Received: by 2002:ac2:5a48:: with SMTP id r8mr5871829lfn.179.1580308462964;
        Wed, 29 Jan 2020 06:34:22 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id d26sm1177418lfa.44.2020.01.29.06.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 06:34:22 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
 <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
 <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
 <5406612e-299d-9d6e-96fc-c962eb93887f@gmail.com>
 <821243e7-b470-ad7a-c1a5-535bee58e76d@samba.org>
 <9a419bc5-4445-318d-87aa-1474b49266dd@gmail.com>
 <40d52623-5f9c-d804-cdeb-b7da6b13cb4f@samba.org>
 <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5@gmail.com>
 <6ebe1e2f-77f4-ae88-e184-c140a911cbd8@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <1f7cafc5-1969-1c6d-6fb1-441854d60fcb@gmail.com>
Date:   Wed, 29 Jan 2020 17:34:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6ebe1e2f-77f4-ae88-e184-c140a911cbd8@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/2020 5:27 PM, Stefan Metzmacher wrote:
>> Great, that you turned attention to that! override_creds() is already
>> grabbing a ref, so it shouldn't call get_cred() there.
>> So, that's a bug.
>>
>> It could be I'm wrong with the statement above, need to recheck all this
>> code to be sure.
>>
>> BTW, io_req_defer_prep() may be called twice for a req, so you will
>> reassign it without putting a ref. It's safer to leave NULL checks. At
>> least, until I've done reworking and fixing preparation paths.
> 
> Ok, but that would be already a bug in
> "io_uring/io-wq: don't use static creds/mm assignments"
> instead of logically being part of
> "io_uring: support using a registered personality for commands"

Right. Probably should be backported there, since it's just 2 commits
before.

-- 
Pavel Begunkov

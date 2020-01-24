Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B18D148C6F
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 17:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388400AbgAXQnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 11:43:42 -0500
Received: from mail-pj1-f41.google.com ([209.85.216.41]:34964 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388149AbgAXQnm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 11:43:42 -0500
Received: by mail-pj1-f41.google.com with SMTP id q39so62622pjc.0
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 08:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bG8ZBWb9qTQWF2E4LSkI5PqIJ9cXSm+EU0VA73oCh30=;
        b=hlSQX1AMKJJWkO7FBRzfnF/ryXM04sb1qgriMDsYWrfSRSv2a4hc5uYZDWLz3BzT92
         9LaUd3DhceH6WrcPR/Y2UrC+PCzbEiiFqhcbr107SUn6pFmQ1TGdJLGpBZVPxYDAwpqj
         7g/0jgKAplL+oNGmO1ZjP+7AQEYpGcvnJasPOLZs1MX5OkEddgGXO7PL/i3QdScE2RVc
         N3Q3yLS7ton2o6SshDLvQ+blXgzZahgwI215qP5TBKUxbqu5X1/Ak69GfI3PWEv790zO
         4GExd38Qa0YmpjhMdulfjZP/HaPTlS75fdoKdzGGoj/9TeFwV5DVMgG9XjpKZyyHghjT
         75+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bG8ZBWb9qTQWF2E4LSkI5PqIJ9cXSm+EU0VA73oCh30=;
        b=GlwPXFfan5LvFA3DKTnfv0ZVtKC47Y2vgNce/hi94qpWPgN55jrp7M4FlIu9fg2Xmi
         +xgjEi9EQwCerznj3+4ntjOJR75vIEDItStJcUfMKqydoJYU78VcCUtehRrd71KK6CUi
         h54nNsP+x8E31S4ihyEteX8SY4G0QnZgp7ruKeFzt2AQwXfqh+0cs5zbTMmFJi7NAmJb
         HAweCdNgzEu6Z+iBmrtfH8eqlglMzMt9ZC0id6SgvkiAZ4Rw9F2lGbp2J7wkVWTCkZXf
         hHRqYHTjOme/iTU9NeHkmYpUYH47c7LAQ6LQCImJAwvJFZRwjRqhJzWlxUSKlfn703r9
         4r3w==
X-Gm-Message-State: APjAAAUcwlPrPosXv8V+wLWOkpse70Zmz5q3fTpMrDn09x9+Q1zhooHD
        9/RETlgN8UuT8OBk0989peznbRDrf44=
X-Google-Smtp-Source: APXvYqxMkTO8WEqN341fRZMxWD+g6rMMxh+2/jpmtv0y9f31n/BHR3w49hDUbN2uLovJrEuD9jFKPg==
X-Received: by 2002:a17:90a:e397:: with SMTP id b23mr78705pjz.135.1579884221373;
        Fri, 24 Jan 2020 08:43:41 -0800 (PST)
Received: from [10.47.243.41] ([156.39.10.47])
        by smtp.gmail.com with ESMTPSA id b1sm6989772pjw.4.2020.01.24.08.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 08:43:40 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <2ba85190-6888-585c-cd42-4cbdd112dee1@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1b101121-90ed-0074-0787-eecaeca88369@kernel.dk>
Date:   Fri, 24 Jan 2020 09:43:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2ba85190-6888-585c-cd42-4cbdd112dee1@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/24/20 2:51 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> Sometimes an applications wants to use multiple smaller rings, because
>> it's more efficient than sharing a ring. The downside of that is that
>> we'll create the io-wq backend separately for all of them, while they
>> would be perfectly happy just sharing that.
>>
>> This patchset adds support for that. io_uring_params grows an 'id' field,
>> which denotes an identifier for the async backend. If an application
>> wants to utilize sharing, it'll simply grab the id from the first ring
>> created, and pass it in to the next one and set IORING_SETUP_SHARED. This
>> allows efficient sharing of backend resources, while allowing multiple
>> rings in the application or library.
> 
> But still all rings need to use the same creds, correct?

Right

>> Not a huge fan of the IORING_SETUP_SHARED name, we should probably make
>> that better (I'm taking suggestions).
> 
> The flag is supposed to be used for the new ring that attached to
> the existing workqueue, correct?

Yes - any ring setup will return an id in the io_uring_params, attaching
to an existing one is done by setting the flag and putting the id number
you want to attach to in there.

> What about IORING_ATTACH_TO_WORKQUEUE?

Trying to avoid something that is too tied to the internals, but workqueue
(or wq) is probably generic enough that it can be used.
IORING_SETUP_ATTACH_WQ?

-- 
Jens Axboe


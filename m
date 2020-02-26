Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93DB71700B3
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 15:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgBZOEZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 09:04:25 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:35842 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgBZOEZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 09:04:25 -0500
Received: by mail-io1-f67.google.com with SMTP id d15so3472522iog.3
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2020 06:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Yki7SuZKtejQzQFZfBecTj+0Akdndkt/c/RT/jlwn3k=;
        b=sAmJWfAmI1Ywapri2cTokZu5YRrf5ZS1ME+XNb2yTKwSduZa/IPDQi1JI8SavOd58D
         unGfl20qFeXQgJTrZoMkGThQqMcW/5Gma2hpxODb4pnBUw3zGkmLqU5O1WzLJSlrVAaW
         tkqtufw47q6IY8X4ugZcMX7Vdr1pVQblUM1nrOSkM3UhLJ9U/4wNA+DqzZEzqZhl3Jhm
         ItoUo8g8zTk4RX0ynvuYCG7XmVCUD1mzHALjyufApSmCpm7uD1/XXZJztjHVnBN3xCIP
         8lT47We4zQyWHVDDTFUFOYjjeCsnW4Yf2ikUH5LwRYyek79sjNlNkmfG1JKtLoGFILhh
         lyGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yki7SuZKtejQzQFZfBecTj+0Akdndkt/c/RT/jlwn3k=;
        b=or0rLIZ5BdPemJkGj7nUuR2szzJWgDgFq3+Db+kzKMsuz4B6I0r6CW1Eds3oPUI/j1
         X3Kw93z4BD2vKO+ybWBj6rnzHZv2k9jgAbhiEvrk7OBDbnjLPTer38/h8pnTt3v1iUzJ
         FHbitGqP1pOigh83GYLkogqPM06kw2MHoAGS3MdC0kKc3rMzVdRk63H7Vp+5kyj4YlY0
         LbJaIB6XQE+n3BNaliUIUmqwm5i5m8enGYOqajdnRBJFyYIygEqwl8QuGfeFJMGln6k6
         f41Y0vxp3oERVVYVxoG8aJVnbISlgseZ8bXF6XPxu+1Tf9ujGyn9+wNOUj2ZdFosTa1m
         GvYg==
X-Gm-Message-State: APjAAAWIfot1RbeSkLtKM9Nl2cfl16nKeIspMiNLPJVhN4bGpCM43dvr
        N0LwRCabr9Oy/fcnfVWyeNSyCEu68ZxIZA==
X-Google-Smtp-Source: APXvYqy82xPXqx+62qlwoqQ1kytiiLVUr7zDFpKEZ9MrUZ/loE3AJHYUVTWP5YEd0oERWc9CghzxuA==
X-Received: by 2002:a05:6638:538:: with SMTP id j24mr4352072jar.12.1582725864681;
        Wed, 26 Feb 2020 06:04:24 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o19sm608560ioa.30.2020.02.26.06.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 06:04:24 -0800 (PST)
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
 <32c9037d-d515-9065-3315-e023edaa4578@kernel.dk>
 <dfc1fc59-46c5-d985-80f7-3d637cd40b13@kernel.dk>
 <14cc6bff-565a-c41b-bb96-7b2edad163ce@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8bd7f576-764f-565c-fcad-55c028e14352@kernel.dk>
Date:   Wed, 26 Feb 2020 07:04:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <14cc6bff-565a-c41b-bb96-7b2edad163ce@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/26/20 1:33 AM, Pavel Begunkov wrote:
> On 26/02/2020 01:18, Jens Axboe wrote:
>> So this found something funky, we really should only be picking up
>> the next request if we're dropping the final reference to the
>> request. And io_put_req_find_next() also says that in the comment,
>> but it always looks it up. That doesn't seem safe at all, I think
>> this is what it should be:
> 
> It was weird indeed, it looks good. And now it's safe to do the same in
> io_wq_submit_work().

It is.

> Interestingly, this means that passing @nxt into the handlers is useless, as
> they won't ever return !=NULL, isn't it? I'll prepare the cleanup.

Indeed! That means we can get rid of that. We should do that for 5.7, though.

-- 
Jens Axboe


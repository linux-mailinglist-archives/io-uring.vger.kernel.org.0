Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C7914B308
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 11:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgA1KvL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 05:51:11 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:39435 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgA1KvL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 05:51:11 -0500
Received: by mail-lj1-f180.google.com with SMTP id o11so14195796ljc.6
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 02:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6SGrr2TWwWViRMBpQ41lI8CpMmyQBAhzaLeugmaLTA0=;
        b=NoZUbctFk/ZxqoWiqOm3Kn7yLzxbSBtG/x5NQdQhninITtRj9e87KLpq7e5o4M5Ulb
         7hvj1r3eBU4rmFlwWHhAWLsP6+hFvJOj4IRh6XdU4J+kSaMV0LiJYVAjuobpOKoe+ucI
         hjOKBtdaurUrYZkNs1yVJl1XxrXPCuinJwVdhVULdP8fhHBJIYmsgKK9rJfdC5dd6y3q
         npHUUwuXjMqyKAcgfT+0rQcyDCZHKNXdwx2V5mkMS529mfyKUVJj6Cr4UNgViGLUcpWy
         KjI1sRnAqybbRxpr0j9F4FPphcvA3Yg6I2Jq7GDhv+bDSv7mmItAN6u2j0HHNJuuW92R
         igHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6SGrr2TWwWViRMBpQ41lI8CpMmyQBAhzaLeugmaLTA0=;
        b=KneLF0aKvVRilDp2If2DQ1DGaVGg820dhszd2UtcH8lIpBSI9JeSYIpg+0jNpjdFNX
         NLTLZV3tXtlJOXPhGn89Tuw0+ttvYs+6WLcBINLiAevl8IkBq8ph6YPBsNR3ovTvOHvn
         uyRiKvA6n4brRjkiA/3c3U9PbhiYE+HwAXkgHEtYKusxr86k7sDd3llxtfRehl3j7oWh
         MTFpJm6xKAl1xzabrP/r/KS6dkDCxJieMOXpuxAsvilcTIZH2yxpZJ32K4/MxQikYZjb
         bm9+V1sukWRfgWgjRkhInGgHTUqT874a5ufyl4qizigOjIBKTTbzSyXXR5R0BhHr57H/
         96PQ==
X-Gm-Message-State: APjAAAU2x46aDf/B6RA5lIJyn8AhfZS9+3Z3RPgblf/qcm87sP9kPbja
        /TP4qptLtsOgjNTeJK9GEV4j+AqfblQ=
X-Google-Smtp-Source: APXvYqzyTwByxfMUI5Qk7ft1cWQMRjgX4FzTaH5FBNf37jFi4PUmdvya3ow5SBXhMwNbRugF9QIwkA==
X-Received: by 2002:a2e:5854:: with SMTP id x20mr4228810ljd.287.1580208668482;
        Tue, 28 Jan 2020 02:51:08 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id l22sm6360635lje.40.2020.01.28.02.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 02:51:07 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
 <1b24da2d-dd92-608e-27b6-b827a728e7ab@kernel.dk>
 <e15d7700-7d7b-521e-0e78-e8bff9013277@gmail.com>
 <c432d4e1-9cf0-d342-3d87-84bd731e07f3@kernel.dk>
 <18d3f936-c8d0-9bbb-6e9d-4c9ec579cfa4@kernel.dk>
 <d2db974d-cb40-36eb-c13d-e0c3713e7573@gmail.com>
 <fad41959-e8e6-ff2b-47c3-528edc6009df@kernel.dk>
 <adcb5842-34c8-a433-6ee3-b160fcb24473@gmail.com>
 <965e6e04-aa4c-c179-06f2-37f0527fb5e1@kernel.dk>
 <e8219de1-5179-4a3b-68cc-d7dbf5c1fa20@samba.org>
 <a8582809-6bf1-009a-3205-231b33ce82ed@gmail.com>
 <75c89c3e-4490-e4bd-8af6-30a20557b7b7@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <81aadad3-dd29-5c40-0400-455d93a1c023@gmail.com>
Date:   Tue, 28 Jan 2020 13:51:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <75c89c3e-4490-e4bd-8af6-30a20557b7b7@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/2020 1:35 PM, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>>> That's good in order to make the behavior consistent again and prevents
>>> potential random security problems.
>>
>> BTW, there also can be problems with registered resources. E.g. for
>> buffers io_uring can get_user_pages() of one process, and then use the
>> pages from another process by passing a buffer index. This is not as
>> bad, however.
> 
> Yes, but that can only happen by intention, right?
> And not randomly depending on the cache state. If the
> application has confidential data in the registered buffers, files
> then it should not share the ring fd with untrusted processes.

Indeed, that's why it's a mild problem. Though, that's better to be said
explicitly, so users know the pitfall. Worth putting into the manual, I
think.

-- 
Pavel Begunkov

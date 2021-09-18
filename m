Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383F04108EE
	for <lists+io-uring@lfdr.de>; Sun, 19 Sep 2021 01:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240776AbhIRXmS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Sep 2021 19:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240331AbhIRXmR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Sep 2021 19:42:17 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B78C061574
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 16:40:53 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id b15so14392701ils.10
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 16:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kwyn6g9fPTNDqpqVrtGL6RMEyPX7RNOwypyafXmQB9w=;
        b=fQBkMuRZNNAx6M6ZUs+3R3DLzERZj8e3sL/ljVwhrDhpcxaU5TFBZx/Hc3TKqqbgTA
         HFHFRY5A+z2N2ut6qeYPA8aYByjMRrhESpJJvmteve9H1T3I9MRD9EMZXY1Lhr8D1Fse
         VOBnbbp5C79rAC8NOKJo+NWGiBRUuyQrsgzq0fjhtweVLvMJgHOhf+5+lSZ2HKzpmEZ8
         QKWhD9ZUrw9bgo8iZjEH/bwoFSP3YOmHcw0Yu3qxiUY+QASlc9YIRqR+DZgatsLOcaP5
         fZvo6wViOYyfjKff20pCntF/FWyYdrcz2I5CTZ9clcVQHRVK1SS5AWy8PxFvA+tZeJ79
         lFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kwyn6g9fPTNDqpqVrtGL6RMEyPX7RNOwypyafXmQB9w=;
        b=Hm/kqX+foavn8OnXfc+uNJYBqIvj0Yt8KAQqVbCMfJeNWedmSqeyO5Nf0dMX3vK7Y3
         wbNOI4D6osndA/VmwlZLQLSoOV6omZ8H4iejoSOWogfrjZoqM0wLIcoyNGbWGkyrrV56
         r320qSdv3Kt7hBSVkGlNvb1Zi1VqnDJ+CWkVx3NKdWoTwipSd2z0zPLqoOPTGjXqPYMP
         xblqDxwRzTv5Ne9JK6a4ATuWcLO/sSndAYkPr9o/BO3MxB7sNqSEmlwacTczMvOObhkI
         t1d2ezC8QOkssyIVZHJ9O34DOsJ8sDdbwHvqMNTXiXlTdSvi9pRCEydgSRsL0kWrMWsy
         TcjQ==
X-Gm-Message-State: AOAM5310qrExsnWAch7ZvPJIolyzjaHngHzmEVybEkGhCaF/h8SNB2pk
        U/bojOSjJ7U3c2AZ0xM2RzPlK2P5/LVxyg==
X-Google-Smtp-Source: ABdhPJzV7I3UxSMPGG9+n5JlVolVdUbL95hp0AIxL/RRcUUkxJs5ByN4vAxM9VWnfEvZ3B+tIN0j7Q==
X-Received: by 2002:a05:6e02:12c9:: with SMTP id i9mr12633781ilm.20.1632008452655;
        Sat, 18 Sep 2021 16:40:52 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s7sm5944152ioc.42.2021.09.18.16.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 16:40:52 -0700 (PDT)
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
From:   Jens Axboe <axboe@kernel.dk>
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
 <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
 <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk>
 <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
 <CAM1kxwi6EMGZeNW_imNZq4jMkJ3NeuDdkeGBkRMKpwJPQ8Rxmw@mail.gmail.com>
 <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk>
 <CAM1kxwgA7BtaPYhkeHFnqrgLHs31LrOCiXcMEiO9Y8GU22KNfQ@mail.gmail.com>
 <d0cbd186-b721-c7ca-f304-430e272a78f4@kernel.dk>
Message-ID: <3df95a9f-7a5a-14bd-13e4-cef8a3f58dbd@kernel.dk>
Date:   Sat, 18 Sep 2021 17:40:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d0cbd186-b721-c7ca-f304-430e272a78f4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/21 5:37 PM, Jens Axboe wrote:
>> and it failed with the same as before...
>>
>> io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7, 8,
>> 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
>> -1, -1, -1, -1,
>> -1, ...], 32768) = -1 EMFILE (Too many open files)
>>
>> if you want i can debug it for you tomorrow? (in london)
> 
> Nah that's fine, I think it's just because you have other files opened
> too. We bump the cur limit _to_ 'nr', but that leaves no room for anyone
> else. Would be my guess. It works fine for the test case I ran here, but
> your case may be different. Does it work if you just make it:
> 
> rlim.rlim_cur += nr;
> 
> instead?

Specifically, just something like the below incremental. If rlim_cur
_seems_ big enough, leave it alone. If not, add the amount we need to
cur. And don't do any error checking here, let's leave failure to the
kernel.

diff --git a/src/register.c b/src/register.c
index bab42d0..7597ec1 100644
--- a/src/register.c
+++ b/src/register.c
@@ -126,9 +126,7 @@ static int bump_rlimit_nofile(unsigned nr)
 	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
 		return -errno;
 	if (rlim.rlim_cur < nr) {
-		if (nr > rlim.rlim_max)
-			return -EMFILE;
-		rlim.rlim_cur = nr;
+		rlim.rlim_cur += nr;
 		setrlimit(RLIMIT_NOFILE, &rlim);
 	}
 

-- 
Jens Axboe


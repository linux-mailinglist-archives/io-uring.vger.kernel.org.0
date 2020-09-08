Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E00326153D
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 18:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731046AbgIHQqs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731943AbgIHQ1O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 12:27:14 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A999C08E9A5
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 07:36:11 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id h4so17327070ioe.5
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 07:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2dj1kh/pZnROBg01Y8KUPMWNpR2qkmrmh3iWLRvCaDw=;
        b=12VNB6Eqcnb3bGjxveKSC54uVN9talXjJNb4XgIlQTzYRThkRFNH3RMqJR3ml57MX2
         tO7U7zW23a2nzZuqsPhbM4dhmAfUJr6inoY6ejpoDGKCttFzXrGG3fB3o8yrIDV9R0vv
         5Hvx6ra/ZY+k0UGEyvWQP9TpYCPABeL7eIc0udUlRc4R8fC+Sfp78eY8/n3V4O5vLc5A
         WWVeBjkqDRagspXWwePPa5MgyoALsf6uZ4eTBVU7alO0rYRTi0000UOvIslIX699CsZo
         4hdIx00IwPexpRhbVC0yrap86IodXDMkecZo89+eeCv4tKKFrRYaECc+7r/IDTjA/9mM
         LXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2dj1kh/pZnROBg01Y8KUPMWNpR2qkmrmh3iWLRvCaDw=;
        b=m5xYTidDZ8esniA08lmKuuszq6WFD0utTn0FGOCaEzpwofVNfvlnuW6dI7hRBlVNe3
         jI6peNdJEUoDUR7HlhghGrHZAVy8ODO/TkNSGOOaJmwcCMcCRwveM2z43rqWBompOu8Z
         ONG/7Emp4CiKneICUsNIPyFBTc3BT3o1hpHU/ACRt/kzKxvWZkITO7RlYtrJwa64SQt3
         Dz4MXTn5vP+yFxUpxZ7Xqb2T95WmC2IVvwH1Hm6/96h5Cc501k4yApEqTf6NsOtEpeRS
         QvQfOlW2/WVQIPo9wFL8GJFv8IuwafjB4Cjgg9lnI7vGm4T+ajVmyvbuqWywxCkw429t
         bZ7w==
X-Gm-Message-State: AOAM530DCzIrtlhijTr6YvTZgwoO+bHMKjXwqb6A0bT7zOhuPRe68dKr
        ftXZcQgfFG7oNqgdVrVDMbyW7Q==
X-Google-Smtp-Source: ABdhPJx0kdRbu0KNHi8H/73WXQk8VZQqfjgmym+zHhLz3VSp6nwnXnGkZEK8uUS3Cw19UNndtsfXFQ==
X-Received: by 2002:a5d:8b4a:: with SMTP id c10mr21515225iot.143.1599575770410;
        Tue, 08 Sep 2020 07:36:10 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x185sm8860775iof.41.2020.09.08.07.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:36:09 -0700 (PDT)
Subject: Re: SQPOLL question
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk>
 <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
 <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk>
 <CAAss7+rgZ+9GsMq8rRN11FerWjMRosBgAv=Dokw+5QfBsUE4Uw@mail.gmail.com>
 <93e9b2a2-b4b4-3cde-b5a7-64c8c504848d@kernel.dk>
 <CAAss7+oa=tyf00Kudp-4O=TiduDUFZueuYvwRQsAEWxLfWQc-g@mail.gmail.com>
 <8f22db0e-e539-49b0-456a-fa74e2b56001@kernel.dk>
 <CAAss7+pjbh2puVsQTOt7ymKSmbruBZbaOvB8tqfw0z-cMuhJYg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cd44ec4a-41b9-0fa0-877d-710991b206f1@kernel.dk>
Date:   Tue, 8 Sep 2020 08:36:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+pjbh2puVsQTOt7ymKSmbruBZbaOvB8tqfw0z-cMuhJYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/20 12:47 AM, Josef wrote:
>> If you're up for it, you could just clone my for-5.10/io_uring and base
>> your SQPOLL testing on that. Should be finished, modulo bugs...
> 
> yeah did some benchmark tests and I'm quite impressed, however accept
> op seems to fail with -EBADF when the flag IOSQE_ASYNC is set, is that
> known?

Nope, ran a quick test case here on the current tree, works for me.

Are you using for-5.10 and SQEPOLL + ASYNC accept? I'll give that a
test spin.

-- 
Jens Axboe


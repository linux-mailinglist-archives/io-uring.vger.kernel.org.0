Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300B52621DE
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 23:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbgIHVWw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 17:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgIHVWv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 17:22:51 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF91C061573
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 14:22:50 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id o68so360825pfg.2
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 14:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=m9XXgq3zR9Ct+LyIjrCLBiplhH2NUQSPXlnlIsAh8jI=;
        b=lPU3uZko3LFyfdBkHdIRfYC3uRtFYNvK4pAK4PdlZPsFcP03Pe0gFe7qs8OsELh8DO
         mkt3iP7W06DDWsiLWtV+ykGBP/4tKOA0Pvi1jn5dsvsnXZ9gPNg7+n6Yl5o9YnJJjbNi
         FaL5RL5Bxc8GS6C6DeV3CD4nGUlIRhT3in1GhGc6VGCvwvEh3Sbp5npxfljC/ihFys3l
         bUdHQRntjZOCr3kZRO2E1x6dOIcgz92v6oz3bGxETJbzu2FUQIttCCGFI6jTCPAPyfL3
         yyRSsgoWm2/xQzEty0TU4bZ0qh62gQzW5xp7bU13FLuLS3JMmcqt8kuKCJnO6IxXPWJS
         Olcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m9XXgq3zR9Ct+LyIjrCLBiplhH2NUQSPXlnlIsAh8jI=;
        b=gLWN4IldRkTYZwHWkQfjnA1LtfoFWC2iXNCz7fBQwHnixcnkBZg047yreJUxqadMJY
         G/QXIeBaWRkFZFUXkEwyddqIbauGo4hy+Kb2ziUv1EvOc2B57j1lnMym0SaM7PCFPqRO
         FDqPVcY4BhQcgRTfa9ndOE9EJqMTGqXLAjYpMYrJS5hUDkfozdAKVEaPhcwDUY8QLxK3
         bhMEsJcEpUffbWQhu4HwCHAq8vPLwu6zgvMYzQESHKoIr5321LIMGCk03gprouKwJQfr
         5FurA/L7IhFHz69itRiSb7D0oZfaK03tnIcMIhAOFfu+Z41ZIEyfQ1YcOaXxprm3ueBK
         1wiw==
X-Gm-Message-State: AOAM533nGr27dF6JFIpBBv/kncpBRbAafH5gViG8XJ9hAUu9umineCqE
        Q8HrfNyd6XgICN2FyfcGy+7l0vd8u21nL2ul
X-Google-Smtp-Source: ABdhPJxuSBAtUdvFTLq42JL6fAKSRB5YGHxQC+ceNBnphh6y98WE/uaVE5nwJKN6lNLmqliHY1R6/A==
X-Received: by 2002:a17:902:fe8c:b029:d0:cbe1:e74a with SMTP id x12-20020a170902fe8cb02900d0cbe1e74amr878310plm.37.1599600170033;
        Tue, 08 Sep 2020 14:22:50 -0700 (PDT)
Received: from [10.174.189.216] ([204.156.180.110])
        by smtp.gmail.com with ESMTPSA id f9sm163468pjq.26.2020.09.08.14.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 14:22:49 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
 <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <622649c5-e30d-bc3c-4709-bbe60729cca1@kernel.dk>
Date:   Tue, 8 Sep 2020 15:22:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/20 2:58 PM, Pavel Begunkov wrote:
> On 08/09/2020 20:48, Jens Axboe wrote:
>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
>> the ring fd/file appropriately so we can defer grab them.
> 
> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
> that isn't the case with SQPOLL threads. Am I mistaken?
> 
> And it looks strange that the following snippet will effectively disable
> such requests.
> 
> fd = dup(ring_fd)
> close(ring_fd)
> ring_fd = fd

Not disagreeing with that, I think my initial posting made it clear
it was a hack. Just piled it in there for easier testing in terms
of functionality.

But the next question is how to do this right...

-- 
Jens Axboe


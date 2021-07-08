Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8613C1A58
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 22:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhGHULG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 16:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhGHULG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 16:11:06 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F42C061574
        for <io-uring@vger.kernel.org>; Thu,  8 Jul 2021 13:08:24 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id o10so7909654ils.6
        for <io-uring@vger.kernel.org>; Thu, 08 Jul 2021 13:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6FkDSNFGNMeFYmrvvMe5tq7VcxOG+PPNZb1/TLh30gE=;
        b=DwZL+I+P616pzgwqO8kJfV/ajeuCPK7JYDUHWFDR85EYlgGTlRThHhsPfVgnykU/JB
         ZdWES2WcI+plXonBUgXQTz0VH82AYiN5HTkP20URANoVjEbn9FSvq8HHK5j897WP1JWf
         1lgeDJ2K3MvK25WJAgga7FhZ4zfgY9a2WwQBNGlD2uveksrkBhpMbA/OK7t1JFmXXVg0
         zp5Hw95HaW5qnlQxXsPqcJQEPUaceI6clwyh12PE9wnP0xUJqmFGL9s2Ntj54LzFLk6s
         P+Zb/+dIaV7hbwEBR/rOe2cXCyRWiDsmJG/IOiGUtke8+e8XxPTDoomvXNRmPh2f+Egx
         qfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6FkDSNFGNMeFYmrvvMe5tq7VcxOG+PPNZb1/TLh30gE=;
        b=kgyjcmioXZBxVkfuK1pmmoM4vtLT0hw2b0BzgkneCbTONpeNU9DXj4f2WO2BaqLMZM
         ech0rqMaiMA+jNHrRWfqhrFQAakFqko2HCWuEuqe2gG84+sYzGUeOSNwAEZhcgjUVm7i
         G6TYi2tymy7k3rM3ucgwDQKC6pn9vsI5EP5g2JbuF1ZN70g4jhUlQYKkOGN18pmuDZgS
         LI8efsMwE2hAA9JVyvIP5bKxVzgrLTr+XWodnZhRX//aQKriGGZPdkjeObrzs231dN3M
         UDh8KSC7fCxTBTq1bQ/Z5k+kPW0XOLfau8EOmDSEy04kGFNoMLwbo+rPsrBXW7HG06ak
         2UeA==
X-Gm-Message-State: AOAM530urc/YwfcFOjpfl/a4pP/AYqvRp4/U/zvgrv1heB/q9uIfBvOV
        ZdNE6nSCNGU+hhrwfM9o+e+DeUPlLe3QSw==
X-Google-Smtp-Source: ABdhPJxNg0dW9SFtYGVNO3ie8Dub0c527zchSTpN+Aq8FOlqOw++/yuuoA63vHXJT9w9psvky5hhbQ==
X-Received: by 2002:a92:a80e:: with SMTP id o14mr23697910ilh.81.1625774903635;
        Thu, 08 Jul 2021 13:08:23 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x11sm1648761ilc.40.2021.07.08.13.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 13:08:23 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: mitigate unlikely iopoll lag
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <66ef932cc66a34e3771bbae04b2953a8058e9d05.1625747741.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6cbc6992-9b81-0221-dc20-bc9bf40fdaa4@kernel.dk>
Date:   Thu, 8 Jul 2021 14:08:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <66ef932cc66a34e3771bbae04b2953a8058e9d05.1625747741.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/21 6:37 AM, Pavel Begunkov wrote:
> We have requests like IORING_OP_FILES_UPDATE that don't go through
> ->iopoll_list but get completed in place under ->uring_lock, and so
> after dropping the lock io_iopoll_check() should expect that some CQEs
> might have get completed in a meanwhile.
> 
> Currently such events won't be accounted in @nr_events, and the loop
> will continue to poll even if there is enough of CQEs. It shouldn't be a
> problem as it's not likely to happen and so, but not nice either. Just
> return earlier in this case, it should be enough.

Applied, thanks.

-- 
Jens Axboe


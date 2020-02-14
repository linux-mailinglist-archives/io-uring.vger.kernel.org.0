Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950BA15D029
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 03:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgBNCpp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Feb 2020 21:45:45 -0500
Received: from mail-pl1-f172.google.com ([209.85.214.172]:44534 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbgBNCpp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Feb 2020 21:45:45 -0500
Received: by mail-pl1-f172.google.com with SMTP id d9so3134076plo.11
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2020 18:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ua/Oe4PqD4ZOnM+trG6adp+/P5Pkukias5LDOYLjiyY=;
        b=k3lqcizhQpXjxHhUhBv8lvsexolRsm28jNHO+n9BjcQApprlBg/iInRdBmkrryDpyu
         ilrd3mFDXCfWyqZtXqpn5P4wkHjkRsbsL81SvWROwparyXNiD12C2eCq40z/+NnFYf10
         f+8QPX21JdgOdIfRqW0qN+WZE146SSTV5HLl2iRCV6NLY9EAwzld9Cdg4fxWFq4buNah
         MrpiWRB/UM0PaWFvwvqXZyK01YUshGG/y3WYGIsCFMFYwzWLey7Yy/OYowsbuAN8B/WA
         LaXDbAWrojLMwCgRlZxCpiCEg3PI3Ww8P1TvxG7KeqoCFbgkFGjKmqF++FNHDQD7ExYT
         lRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ua/Oe4PqD4ZOnM+trG6adp+/P5Pkukias5LDOYLjiyY=;
        b=BA7XZFzapj9/8yqxwlsHRq2v007fISR+gNGgE5Ms9V4zQ6UXeWcx+JQj0E1VlWkSwg
         ap4mYaQkyEVZxo6LAjyW0Ox1UpNSm579PwBV0SPPtIjAMlsqmsXBR0rBZSI+sVX3JPuK
         Jg5l8ovjm90niMIoxi+nx+vy20tDQ7HlnzCCOD5C00BQLZbChrWv0mg3NNs+dRG2d36l
         lZ53Q3WjHC+LwFcK0epJDVmkOj1ydXVoDRhb4l7envg0W9aAuKSb/nGbF5DeGTwavj4m
         Z5t3lcAqk4qAxH5zCpZw9+ZUbdnrfuL94AI8Ttda10c20XBigEcewozfuvs2KR2I9Usn
         kZGA==
X-Gm-Message-State: APjAAAVw8215im5vUeOt95mMMMfdxV71OgdlK3HT6D1ZpuE2isYDCHbw
        J4N04uBoehwNGPhop4lLNCojGi4HOzw=
X-Google-Smtp-Source: APXvYqwx7L26L6OjysHLyfP3SrhviU7g6UaMBSHHqyVkxYBWA+b2CqPYHUjud5ZVIB+IYIbKGYfAWw==
X-Received: by 2002:a17:902:7d8c:: with SMTP id a12mr1048190plm.47.1581648344625;
        Thu, 13 Feb 2020 18:45:44 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id l69sm4663298pgd.1.2020.02.13.18.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 18:45:43 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
Date:   Thu, 13 Feb 2020 19:45:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/13/20 6:25 PM, Carter Li 李通洲 wrote:
> Another suggestion: we should always try completing operations inline
> unless IOSQE_ASYNC is specified, no matter if the operations are preceded
> by a poll.

Yes that's a given, the problem is that the poll completion is run
inside the waitqueue handler, and with that locked and interrupts
disabled. So it's not quite that easy, unfortunately.

-- 
Jens Axboe


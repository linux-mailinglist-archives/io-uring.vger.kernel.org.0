Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39BD1CC292
	for <lists+io-uring@lfdr.de>; Sat,  9 May 2020 18:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgEIQPa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 May 2020 12:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbgEIQPa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 May 2020 12:15:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E8DC061A0C
        for <io-uring@vger.kernel.org>; Sat,  9 May 2020 09:15:28 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 18so2562140pfv.8
        for <io-uring@vger.kernel.org>; Sat, 09 May 2020 09:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9RfWoa+OyVYhRyq8fc6okRxutf75i2JHWqqPNgwLqfs=;
        b=a81IJUwFIPM1Hc2xgPStppkTlfmxBdDHqDcxpgY/XOTG1fwZPckIMxmaW3YINucx/H
         kcuekRUoSNd66nE02LkNOTIxd4XqUPooYRo8WYcx8vzzDT6xbWNX0ejrbqSPv+zHTo86
         QdMELaRNrcpmyyZ4bIQjSefkyz3xp5ry4wUAHVNHdfQIt9QzBGR6kk3H8NOb7fAJ4qqc
         NjliGsz3Harvl+UG5hvG9aAjHy2D37LAgyNDJLfhn5CVvIuEwyVauo13CtRBeAWFGwE7
         1L3JVI6z1qLd5tJslvF/Fvt2Hq7qAXu5VikKYMR0Cup/xHIox+U/z89ifcqbLm6YmU9F
         k4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9RfWoa+OyVYhRyq8fc6okRxutf75i2JHWqqPNgwLqfs=;
        b=YRHdqc3ibMnNk51rrRuZw0K5VgaSznGSsCxhffLTqv/0JFYKVpoKMitvkO+9FYu7q7
         KD3MH2hoixZUR+I4SAjW3qRJvwHhjXfnsKuZ3ONThBPI9M97YhNIYCbFGDzTUutcnilt
         28COLxXkF5DVCYxvV1Gq88vMqHNgusW6wb8aiRj7OZj5E3IdwPHz+3Qp6WhVofwIBkWx
         Xj4wsZ52i+uX3FoI7B/M9MR6qhgYJqrjgx5LpL5es1HDwRpLF5TDQtYOnVz3F7Q/bxm6
         cjy8NFGBLKe1ef/kgJPDFejH6LnEEgMWSvxj1OtnHwfSO6M8WGyNik6TPd8wzEU5LuP/
         6BBA==
X-Gm-Message-State: AGi0Puasx1l1Xu0kdF7ND9IWYJD+lGd58QaCcUJaQOG5WBAg5Ky+HYJ+
        xutSoMT/oXyYih7fcS3tkk+Y0A==
X-Google-Smtp-Source: APiQypJTJwqxmrzhdmttmXW+QEBXc3SNvFkZ5mkyj4gdo2+P/cFptDi1ZuE81TthfzHU4hk2p9dWyg==
X-Received: by 2002:a62:3784:: with SMTP id e126mr8525998pfa.303.1589040927999;
        Sat, 09 May 2020 09:15:27 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z1sm5162042pjn.43.2020.05.09.09.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 09:15:27 -0700 (PDT)
Subject: Re: [PATCH for-5.7] io_uring: fix zero len do_splice()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <c7dc4d15f9065f41df5ad83e051d05e7c46f004f.1588622410.git.asml.silence@gmail.com>
 <102cad76-9b98-444f-7ccf-6475245f4031@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5c24bcbd-cb68-1929-d3f4-389fe599e8f1@kernel.dk>
Date:   Sat, 9 May 2020 10:15:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <102cad76-9b98-444f-7ccf-6475245f4031@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/20 10:07 AM, Pavel Begunkov wrote:
> On 04/05/2020 23:00, Pavel Begunkov wrote:
>> do_splice() doesn't expect len to be 0. Just always return 0 in this
>> case as splice(2) do.
>>
> 
> If it was missed, may you take a look? I reattached the patch btw killing
> reported warnings.

Thanks for re-sending, I'll queue it up for 5.7.

-- 
Jens Axboe


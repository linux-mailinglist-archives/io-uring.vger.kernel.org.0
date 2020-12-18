Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA792DE649
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 16:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgLRPOg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 10:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbgLRPOg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 10:14:36 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D15FC0617A7
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 07:13:55 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id y17so2531737wrr.10
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 07:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/gH9xfLCPiqzi2VJOt4d6j3IDWtvSZElcaDHGVq7CU0=;
        b=LCnZ1PQcDZVPbqMXTWF5NymOrAmF09y5ApUiEXpFIl15bGJH81/cv1N+8iDx80jPsz
         H2gDI9TMfvyROBi/Wp4vjHFuWW0LI6hQjALEqz4E42u8izoohE1wIgWf0J3P4YvUlHqe
         bHa7g5tf32PelmORyXM+uk+uyh4eyh0ixrazRB6PEk1BtxM10gmgs9HddXmjeNCP8/pp
         yg7wYDRWfcC11ee593ygQfVTEyumpiXwqW/s4YR3In1WtHjM+PzePgrSBWYwfK1by489
         U4KDtwkdVWIejGcDY7AmAkW53TdIWCoL+vw12Ls4uOHj5f05hjojIWDSeyxeGRyTnPZ4
         S04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/gH9xfLCPiqzi2VJOt4d6j3IDWtvSZElcaDHGVq7CU0=;
        b=IWpdGkzIh9wqpv0hRTqCTQCrwNLUdUljDPDbLK/Z1vniUrmxTNqsHEvWhKD4pVND4/
         WN7GY4XJd3eObvjtBRhZi4ynP6xQI5hyRHNM794S+QtCisHghY5ai4IFyZgeli8v2lM4
         5UNsvUaDIu8XY12i6UkWnCQCl5VYGYnOj+cMtMg5eM9r6/XDjqPoa6rtmf3hC9nGi+Em
         gmtI79iLeJPaZk1lx6oud0q1D3kNlMhhVxzwRbV4B6wj0vzigrn3XD8UEkeT1iJbKqoC
         klZZr8RFzrEGWhSn9Y+b16JTmOLkr5qSPg/Zf1u6bYSOYPPTbEQsg+LV/wjr0if07ist
         LTSA==
X-Gm-Message-State: AOAM5313HgIpGVaeGuOBe9OV3ShE2CsJ/05C5+3G6r/5S1lprgLqTIrI
        vhPZ451kHaBtZ8jbsosD76M=
X-Google-Smtp-Source: ABdhPJz8hqxUi0bWRSnPqBzSp071Ut+szs/ffjj+hZACtmPEyDkqR5yuMxDZa11bHJmyPw8qOnSgjQ==
X-Received: by 2002:adf:94c7:: with SMTP id 65mr4800358wrr.423.1608304434235;
        Fri, 18 Dec 2020 07:13:54 -0800 (PST)
Received: from [192.168.8.132] ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id l16sm14447720wrx.5.2020.12.18.07.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 07:13:53 -0800 (PST)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20201218072648.9649-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: fix io_wqe->work_list corruption
Message-ID: <6bf40c10-0995-c5d7-0e2e-4129881be0b5@gmail.com>
Date:   Fri, 18 Dec 2020 15:10:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201218072648.9649-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/12/2020 07:26, Xiaoguang Wang wrote:
> For the first time a req punted to io-wq, we'll initialize io_wq_work's
> list to be NULL, then insert req to io_wqe->work_list. If this req is not
> inserted into tail of io_wqe->work_list, this req's io_wq_work list will
> point to another req's io_wq_work. For splitted bio case, this req maybe
> inserted to io_wqe->work_list repeatedly, once we insert it to tail of
> io_wqe->work_list for the second time, now io_wq_work->list->next will be
> invalid pointer, which then result in many strang error, panic, kernel
> soft-lockup, rcu stall, etc.
[...]
> To fix this corruption, if a req is inserted into tail of io_wqe->work_list,
> initialize req->io_wq_work->list->next to bu NULL.

Looks fine, and the function is cold to not care about overhead.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

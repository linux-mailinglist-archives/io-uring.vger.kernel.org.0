Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2959A3B96AC
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbhGATnq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 15:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbhGATnq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 15:43:46 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC50DC061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 12:41:15 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id i189so8955187ioa.8
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 12:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8o3ftf+cbTqID1QqHSiBiR89uXKIoOa5dA68xj0k16w=;
        b=dOX894ds+BXoJEGIPCSxJxquIbvL3MneH5fbWpBiyeonSQ5WcrspVoC1HWoeSiy59X
         A001/mOCeeDqLqKjAuzba3XfuN6MaSh1mautKHttNx2KMQoHFiyhv2Hgr/Z4eNlFxHVT
         c9z3TUFqrhZE2VhIktArufEsRkzl0z0zzb08uwk29kuejEO7Ml/r3bpTlvGu/WQm8UIw
         IhYmvO8CrVT7R1X96sskgRSe2R+yRIHqHw1ieXqG45u0/eKaAiFsh1c3S/ULX/88LL54
         3U07ZaNf+4+Za3W0fVKIWlsL+iGH1rl+aIilMwTcQ6VaA/k3tUrBJTbpAQkwdd7PJyyj
         Z6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8o3ftf+cbTqID1QqHSiBiR89uXKIoOa5dA68xj0k16w=;
        b=lTX0BIU8g3/kS/v6MhI0C+/rnNXeccC9pXR/budt+UVYFod9BAUer1aLsdyWD7qJbt
         jrC/PimSNZDyok7ccNkqGHjsurqbUT/pPxJAhHUjr5V6cGN3IvCy1RIoAwcsaLYwnws9
         BnT6RhABsuHP9Ug95O2j0Cr16Iw+q1Dr5OxYOKwiUy0OAFZpFIH9stV8/djPHX0M9GGW
         gLVR2xNkULamjd5zaCh3n9BfAKrM4U+ZLIfbhhlcWKrSWFDEvDiL8cy0KakmF4g6aXwB
         4+WUR0OOAJ2FDV8zYpNTBH2sZFIDjDFUxpNZDc8XbBD8kS41LN/YCNyL+AgNA6/FY9Xw
         dJGw==
X-Gm-Message-State: AOAM531xqsLVmi1V3/Tvuu5D78WpwtGtZlFEDQfvUE/V/enzntc9CSO1
        XBMWhgCQvAmytQ8guyOa9afKDDU/LLBGsg==
X-Google-Smtp-Source: ABdhPJxvQc1Wijvj9TiAMKdcrudBTEklRfYDNSmey4rYZuraEGzrjovs6v5WLFtbAry6VRtg7T2yfg==
X-Received: by 2002:a02:cb49:: with SMTP id k9mr1260697jap.95.1625168474920;
        Thu, 01 Jul 2021 12:41:14 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 17sm384544iog.20.2021.07.01.12.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 12:41:14 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix exiting io_req_task_work_add leaks
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <060002f19f1fdbd130ba24aef818ea4d3080819b.1625142209.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c92b117a-5bbf-27ba-e930-74e17776003a@kernel.dk>
Date:   Thu, 1 Jul 2021 13:41:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <060002f19f1fdbd130ba24aef818ea4d3080819b.1625142209.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/1/21 6:26 AM, Pavel Begunkov wrote:
> If one entered io_req_task_work_add() not seeing PF_EXITING, it will set
> a ->task_state bit and try task_work_add(), which may fail by that
> moment. If that happens the function would try to cancel the request.
> 
> However, in a meanwhile there might come other io_req_task_work_add()
> callers, which will see the bit set and leave their requests in the
> list, which will never be executed.
> 
> Don't propagate an error, but clear the bit first and then fallback
> all requests that we can splice from the list. The callback functions
> have to be able to deal with PF_EXITING, so poll and apoll was modified
> via changing io_poll_rewait().

I applied this one, adding a fixes tag too. Thanks!

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581881FF4C4
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 16:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgFROcs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 10:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbgFROcr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 10:32:47 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1EAC06174E
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:32:45 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n2so2495836pld.13
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rYLO0ARrI7ErjIzTNgGcr51P9vXBU1mF93hHf0YakPg=;
        b=0yAplFucfBYvjNEQ6NUxxm4i7HUxU9+azZ0w/V7elPCz4X5W1KrKJ7vFdbqFSvA4wV
         JKesC3lss8NdbjDQYurqnM/8mT2vbE2jiTThArYGWJAfhKLnKWg7cyeQZmLdcRqAJQxC
         G9HtZe+uY34ZnqdKVMPmZf88EmM1RDVHBLPB/hw9bqDlY8LwcyDsBpkok1NSzpo5ZWc4
         UZZYdjJrn8PTDnrXEV++lsxXZwdpbdOeNS1oIlTLfgWA4RTlmgoCGSu6zExK61nD/rNX
         +q50NYtheo0j70DjrJdSwZUOiBDbIKOUFr7Wq9mYYoGRTjwN1+AMi+8P1YoVf6JvH672
         DLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rYLO0ARrI7ErjIzTNgGcr51P9vXBU1mF93hHf0YakPg=;
        b=Ayv4MNp/ooIZINYF1WjRJRxP1viO9BGaKASPL7SDOtHDNJfeqdjc06Zk3pzNGpmjnB
         /criUau4X6ZUHjVyfgdvLYc9cCQWizrTMTntzBQveVZKzgvld8DgtkX05rV+XHhtJbnf
         /LEBLm30uYU80tMnoGNT45prEYFGWGunZLFdLqS+6OfmrmRRNzsacFsCoJwNymVSVU7y
         ryBteoL34JbezlxZU3j/DJ7pqIR4aESo1qNjBnm7xb7tkODQtM/5HNK9lQlZ0EYEA0Qh
         4q/v0ZjoO1KvS4geRznaZD6RYeACA9NwBTvwzW/SI6EtfKCKU0N/O1cSd++6MsKfn1Dl
         23Tg==
X-Gm-Message-State: AOAM5334CeDdX/uZnZHpCokEv2dAPq4bUbs9pmkils/Q0vizcWK/oKRy
        exu8ieQKXgmgNQF6CN43+5Lxfs0skgyLvQ==
X-Google-Smtp-Source: ABdhPJxg6ndVtzZJHTA8G3GOOmrOZVT4vQLyj2moxsbaZw8BpFLLaAdN4colrQ2ccn7cF2v80x8jGA==
X-Received: by 2002:a17:90b:1009:: with SMTP id gm9mr4603336pjb.213.1592490765028;
        Thu, 18 Jun 2020 07:32:45 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m22sm3317637pfk.216.2020.06.18.07.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 07:32:44 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix possible race condition against
 REQ_F_NEED_CLEANUP
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20200618070156.17508-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <603f31bb-6a2e-1d93-04e4-6499839b9f01@kernel.dk>
Date:   Thu, 18 Jun 2020 08:32:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618070156.17508-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/18/20 1:01 AM, Xiaoguang Wang wrote:
> In io_read() or io_write(), when io request is submitted successfully,
> it'll go through below codes:
>     kfree(iovec);
>     req->flags &= ~REQ_F_NEED_CLEANUP;
>     return ret;
> 
> But indeed the "req->flags &= ~REQ_F_NEED_CLEANUP;" maybe dangerous,
> io request may already have been completed, then io_complete_rw_iopoll()
> and io_complete_rw() will be called, both of them will also modify
> req->flags if needed, race condition will occur, concurrent modifaction
> will happen, which is neither protected by locks nor atomic operations.
> 
> To eliminate this race, in io_read() or io_write(), if io request is
> submitted successfully, we don't remove REQ_F_NEED_CLEANUP flag. If
> REQ_F_NEED_CLEANUP is set, we'll leave __io_req_aux_free() to the
> iovec cleanup work correspondingly.

Thanks, good catch!

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367EC33190A
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 22:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhCHVGZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 16:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhCHVFz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 16:05:55 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520C7C06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 13:05:55 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n14so11557837iog.3
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 13:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cdjl+wCJUi5cKCNeWlSr+GoV2W+UCiWXNnZr5SlQkco=;
        b=D7Mx+rOvzJp5jTSb1yb+k5yhqB0AAnXRuqwBCQd923tztSI7VUSLbDd2SfLlNpSxGr
         IL1I76wYnCRGpYuanvak9YBs285OpszOwoYo0DT/MLHoKgwEEAfySCj3seb4GSU6mr3k
         I9MJwLEGTwi0jS1E03Gneu2+aa9Bmxd618zbapVpfaXWizVtQI1X09+ygg+fj1IlIxrF
         QaS/4VAwycaAMMuo6PDd1gxAJBWit0Kva2ZquKnLof3Vm3yw8Mj3Ej5EYbvwj4Ihfzg3
         Jgzq4t8dkwxJ0CPMiMzvIbYLShsr3ESbpgYdzx80LaPLmET3tFvAlFr/zmt0IKjtAtx5
         6mfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cdjl+wCJUi5cKCNeWlSr+GoV2W+UCiWXNnZr5SlQkco=;
        b=qmu+8zbTaecYp68FILoHDKP6WyfEwaobpFTSNJzYelhOZ7fJdftRIhGIfKBzZ2bCrq
         TcblesmB7B8Kwo1ACuowUv4ChzSOetfe8KxvMATzL0O+tvQmT1xQmymK1YE5crM1LeVj
         F98Da8nmCr6j4i7IDWOUPLl3MQWB/oqoR1A4VRGiF8zBvIc3FP+IrIM0IUFyuKP1r5cx
         UZ2hVNklAqZuhN0dLnuf+dXF+bB8WanH5bWHS+DXm/TGan35oSsJEOHqjJgl9CDFN1TK
         EpgaJ0qMjxOE9Sg0S8/Hm5qy0IAgyqJ2BpG5AnfSbukgmCsHuTvwj5PDrFOjdCy6M/G8
         43Tw==
X-Gm-Message-State: AOAM531qxFI/5BbGnCKKYqh5/S6rcIZpHqk8fYnrLaSjMNbr6gepx9Hi
        ndXAcfgdcBoZ+jmZH6W8hBcD1hftCS8Fwg==
X-Google-Smtp-Source: ABdhPJxw4zq2WueU8xAuM5+/XNpINZ/ASsiEkKWpkx6tQbEbE5XKbTe8my4kyLiLcpVrEr+GdCTY2g==
X-Received: by 2002:a5d:80d5:: with SMTP id h21mr7772128ior.11.1615237554511;
        Mon, 08 Mar 2021 13:05:54 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y20sm6871088ilc.18.2021.03.08.13.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 13:05:54 -0800 (PST)
Subject: Re: [PATCH v4 5.12 0/8] remove task file notes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1615028377.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9fd26154-d491-0963-52a1-407963af6855@kernel.dk>
Date:   Mon, 8 Mar 2021 14:05:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1615028377.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/6/21 4:02 AM, Pavel Begunkov wrote:
> Introduce a mapping from ctx to all tctx, and using that removes
> file notes, i.e. taking a io_uring file note previously stored in
> task->io_uring->xa. It's needed because we don't free io_uring ctx
> until all submitters die/exec, and it became worse after killing
>  ->flush(). There are rough corner in a form of not behaving nicely,
> I'll address in follow-up patches. Also use it to do cancellations
> right.
> 
> The torture is as simple as below. It will get OOM in no time. Also,
> I plan to use it to fix recently broken cancellations.
> 
> while (1) {
> 	assert(!io_uring_queue_init(8, &ring, 0));
> 	io_uring_queue_exit(&ring);
> }
> 
> WARNING: hangs without reverting sq park refactoring

Got fixed separately - forgot to write that this series is applied,
thanks!

-- 
Jens Axboe


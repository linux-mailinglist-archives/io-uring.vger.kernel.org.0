Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633DF3FCF0F
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 23:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhHaVXv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 17:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhHaVXv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 17:23:51 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A34C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 14:22:55 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q68so538225pga.9
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 14:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LS6KxgfeltEdPfUsnMJNYzVNbPOK2pCBIFDrPgmvt4A=;
        b=TXS5wty9gDlQdP/wVrrpXLBigqD05LAUlHv4wknUdU9Qkg/IVukKjFzQ3uJNSRH9An
         dPGXJ720gEnMI3Ch1Jy9sVW9vST820kQTs0OpLsOYDSS6itseAV/THte1zOg/+6lYzRJ
         wNdzdxiBy+Egd86Ew5lalaGp0ie0mNtK/78YrpKB/RFrkGAC8W1rP8rZx66lSqbRvUlL
         6J5MnWNrwyLmiZeNfgda2O+Ik+QcxKT420+7Z6djtEwjbmUA89PbMCxDkKmZKkWJzCfT
         uq+vqQavRDGXNTyJod7MvPGaPd/CYn8L+cfM8IcBQme5SUOTiARgwpwkfQm6oYHpbn4R
         D7yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LS6KxgfeltEdPfUsnMJNYzVNbPOK2pCBIFDrPgmvt4A=;
        b=TxMc65o4oWlhQFTC7stroRbCfidAGEBmMJkvC3sVueMwOSLZCoTD+FQnLS95tikLZb
         8ZooNI5Z/5anq0cVk6piEiqND08LZwDgjOh9VNL+vqWfnIZa+EzOER8LyHvmo2StNmy0
         ySftPzpeBDeDfWHQ49sV2sDMqBs5IwQglrpXTUJo8i5bt9Gsg85xeJhhdYz9uVrloepj
         XHOI1WbkKiJRNlxiOtc6kNNYvhDtxs4Kghf821hSqnYCD1sL17PTQY883akmkSjDlkiP
         Z/yG7YUmF6Qsk8B2zvj9XwKzPOEAiUrIGIT5b9vAJdeYdKnVUqRb2LxL0XEFaMXkIRcT
         AalA==
X-Gm-Message-State: AOAM5311JDEYg8c4jChgDyHwj7EWfTdGEKu81fgEzIJJrXtKEUUO8jXQ
        72mJEIq1CkreEoYU7p5L0fiOV3dOYlYuYQ==
X-Google-Smtp-Source: ABdhPJzkACX51YKYI9Fdm+M6AVd/kn4YT/ny2dMoo188MMbzDnOx1YE3i34vfOXHvO9j1C8qouImFA==
X-Received: by 2002:a63:4563:: with SMTP id u35mr28265978pgk.275.1630444974482;
        Tue, 31 Aug 2021 14:22:54 -0700 (PDT)
Received: from ?IPv6:2600:380:7527:1fc8:f773:294e:edbd:5388? ([2600:380:7527:1fc8:f773:294e:edbd:5388])
        by smtp.gmail.com with ESMTPSA id b5sm14376517pfr.26.2021.08.31.14.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 14:22:53 -0700 (PDT)
Subject: Re: [PATCH liburing v2] man/io_uring_enter.2: add notes about direct
 open/accept
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cf33283b0f2e795ac7f9b6e2eabc70a4f71863c0.1630443189.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3a8fb3cb-aeb9-bd0c-36c6-6423ad0156d2@kernel.dk>
Date:   Tue, 31 Aug 2021 15:22:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cf33283b0f2e795ac7f9b6e2eabc70a4f71863c0.1630443189.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 2:54 PM, Pavel Begunkov wrote:
> Add a few lines describing openat/openat2/accept bypassing normal file
> tables and installing files right into the fixed file table.

This looks good, thanks!

-- 
Jens Axboe


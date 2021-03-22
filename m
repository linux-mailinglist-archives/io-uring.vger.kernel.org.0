Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D62034460F
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 14:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhCVNlu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 09:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhCVNlU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 09:41:20 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461E8C061574
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 06:41:20 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r17so8651558pgi.0
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 06:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=okq6RapDf2zvgYoWVrWtuVxxHR22i9CpetCe2NMJfLg=;
        b=Q5T12NQHdyFD3XS6Iv52KAFHGNB0COAZxhrFKRFCs3kel+zhlNQeWedodjwjZ/oJGa
         jMuFNwSr7i4ocBqLDeEtkgNnrd/frBTVSiVLkjlR+Zx1gZoeQdHSk+obM88r3vtEP6kW
         QfzAS7WF5mSTqpLQqyN1fMa7R5ufUIlZSfXgHoZNCEF+WmzMMYlUJv5huue46WAsBUUp
         0PNMFtqLFRMb1l8t4cibq/xVD2uLKvWiUvlO5+sDBcNAM8x8WMUyjL4gF2kHeKWGilbF
         1Fo7THuwU5SNQwSl+fmI8sazu3q3YJe48BGXOVcYLhiuOY9X+s4oMiEEBhm837EOFm57
         SyaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=okq6RapDf2zvgYoWVrWtuVxxHR22i9CpetCe2NMJfLg=;
        b=qwfxJ5hEaPixPYcCLvSThSPtNo3msUIKF7IDMFPgp7uhIZwBd1WPCp9a8DjfC7eHnJ
         pMQkiyEAVpCpyMpYJaxpmWyBqhgcZ4CMERzv89jOHrHceYHHmgiy/QwZpeRNm+/Ddwv4
         KsMv92D4Bcv1FM1V3mR4DONyWLFtnzUUCMC6b6u3pl7gbTn3az0RzbF0xA8uiF8GGoy7
         Ed7ZahQ7eFKDaUHCqlN1fYIferLLdbc8yVxbWoj9MtNsGebSw1BJV+MywemhLmfYcjDG
         TI0Bdj3f/tirnqD2vqpuCzk40oyyHHoTnpzXZZkCBFXN2+iitTxeNzhcAfS443reWKRP
         8fFA==
X-Gm-Message-State: AOAM533BQ8zH+/5MKatLtECtSy7ypaRLo1C/q5lvI9uvA6xWhoPIOHWj
        cOa0AKrngSX1NUrJQdHsRWJTxQ==
X-Google-Smtp-Source: ABdhPJwaWM7JoNCY96hTGRHnPSm9X1zVrZ9x98tEo1dL5FcqIY97lQWKX8QXeLmGHYVpUfimcI9rNA==
X-Received: by 2002:a63:3102:: with SMTP id x2mr4080664pgx.123.1616420479810;
        Mon, 22 Mar 2021 06:41:19 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y8sm6828882pge.56.2021.03.22.06.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 06:41:19 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix provide_buffers sign extension
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>
References: <562376a39509e260d8532186a06226e56eb1f594.1616149233.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7b34b4c4-251f-127a-3683-972025da5b1b@kernel.dk>
Date:   Mon, 22 Mar 2021 07:41:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <562376a39509e260d8532186a06226e56eb1f594.1616149233.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/19/21 4:21 AM, Pavel Begunkov wrote:
> io_provide_buffers_prep()'s "p->len * p->nbufs" to sign extension
> problems. Not a huge problem as it's only used for access_ok() and
> increases the checked length, but better to keep typing right.

Applied, thanks.

-- 
Jens Axboe


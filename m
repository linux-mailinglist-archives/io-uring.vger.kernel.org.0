Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145D83F4E2A
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 18:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhHWQS0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 12:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhHWQS0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 12:18:26 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D39EC061575
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 09:17:43 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id v33-20020a0568300921b0290517cd06302dso37699234ott.13
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 09:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=S5EsiOUWYKPrtViKwQmiuNFLqo1LdceyCxbM3r5JFmY=;
        b=YiKd+d1DzQFUJultMPXo8pJPc/T8lVBeg3qN/soBKtHbnG3yWFY9TFFAP2t+6GTa3y
         6PeScyvcfG6bR2vqbS8Hrg2xWDAP5uUD6P/+f8X/azeuEbtyG+tJDLlkswpPaBQzIlNO
         xz9MIvcDl8ctOByADv87AQh4RhTMNGA0NiZZ5PubsjodvRHcMjZOf996oB/Yq+gGU1XG
         X+Omlt32ifb2uS6xGDXSpvjbf3IIM4nzHJyAlx5i4BaeZmHLHgTOiNb3dGREK3xWSCnP
         oR37sTXyyi6T/1P/rUE+3/ipndZH3l/BGjwqdMUPCWnfwcVBHOx01zA/VpCuf79VKz3e
         1COA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S5EsiOUWYKPrtViKwQmiuNFLqo1LdceyCxbM3r5JFmY=;
        b=UTLJYOxxITE3vJoKESS+ITRZkcT6buzT0T7C1p4VvogIP9xSmywnj0SCMVsc4xut5l
         gejOfB2alq+fpky+n+0u+FNG0f1gj0lXekGB4vg4lAURLJQl72/6+ZoWR9MWeoW0IsnC
         gt3KdvzQPTfGXLDwvWmrux+OrrmTF5R+HLPaooevzBuemMj2MiKF2WMQChd0FVd9pOj4
         r6QzgGpzuu4/ONDPwhX4bz+vFoRy113gNw4OBaKTxN8FNiAaK1RViDOEApbVbQwi24wC
         SJIBr14qDi48rK3i10mDSQGZ8rcWfPFXwQ9jV6JsR+bf331OnfFYM8ngYI3A7SEVAs3i
         9lPQ==
X-Gm-Message-State: AOAM532v+g95AoW6hmOBX0241oMA1k5pJOcv+O4OZUDJs7HZKh1xUh/b
        n7vH5+w4QKLbeWW+BQ/MdfyP1R8zAO2FMQ==
X-Google-Smtp-Source: ABdhPJwtUKOqzld0b79wGqB2A1ZdzmW+xXILWLK/zilJ5Rnis89NmPQAdpLoPEOkhCEDHOMSD6X03A==
X-Received: by 2002:a9d:4590:: with SMTP id x16mr28193944ote.94.1629735461500;
        Mon, 23 Aug 2021 09:17:41 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p4sm3441125ooa.35.2021.08.23.09.17.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 09:17:41 -0700 (PDT)
Subject: Re: [PATCH liburing] tests: add IOSQE_ASYNC cancel testing
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <b5dada6cba71207dd8b282a805714a4fe8db2258.1629717388.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1b49190e-9ef8-8b09-d340-f80c9211a3fc@kernel.dk>
Date:   Mon, 23 Aug 2021 10:17:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b5dada6cba71207dd8b282a805714a4fe8db2258.1629717388.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/21 5:16 AM, Pavel Begunkov wrote:
> We miss tests for IORING_OP_ASYNC_CANCEL requests issued with
> IOSQE_ASYNC, so add it.

Applied, thanks.

-- 
Jens Axboe


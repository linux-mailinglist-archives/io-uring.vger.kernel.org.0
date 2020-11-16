Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCE22B4B31
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 17:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbgKPQcI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 11:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731554AbgKPQcI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 11:32:08 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBB4C0613CF
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 08:32:08 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id q1so15791370ilt.6
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 08:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BgapheT6xk8T3bgAiSsIxUfFi2/h5m1DE3gO/1pJMCc=;
        b=d+ZMcxp4c7NDlwyg5T48Gq1sJr7kREUJibAXS21jXpicMBwMo6yD4ciTLP9M0yTVMV
         Xk6HR+EhXOiThOBwenEmFWAuTm11Y3kUy5d0X54TCoWalg0wLXFB79mMuv+ADruJEFwU
         IkVdTosRlkRAQmmENP2hTaqhmnXpResa0uhxgwpqfRgtRxUcgmyJiMXY55Su/diL134R
         Dgn/VPbKlilH0E+zuAEXAe1siCINcQ4ExTNrZfsfEVPB5i27Ln2fMqmZaLjH0b0qFVDU
         hDEKKXH+9E+JBTItgFIBO5v0NnElhpHfkuGMGVJLx5Fgbdj+hG8HujIdsFONn5xrdcrn
         aBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BgapheT6xk8T3bgAiSsIxUfFi2/h5m1DE3gO/1pJMCc=;
        b=ZGyDJJCfEEK2OA5DxUTrntdUQ/Hz/620+bppcTUk4T3ztMek30o7r0LXy92KzlsStl
         +CaQHeAQcpkPBzDLhKCoqhY0U5bxJ8lL42TSdQthNGXPpjDqa43ag/MsyxlyLyi4jjn1
         /rZ9nG4oKk1UMITJbD4wneciOdcs58VIz4SbPZVFVl3N6D1rt9QaQjzpLBETEHvUVBwL
         6hnJZhcafuLeMtfPuBZjTFMnLlPCzW5zgtkodnBn8pQY8zLzxH0t8U2i4dO3bs/bV053
         UhVdvLXzzPCSBT3ORRNoB8YefdKooeDfgI+15S9WrZe8rPkH7h9JbTc6QRQubj0BIyaL
         0b/w==
X-Gm-Message-State: AOAM530n+RV68omgqz8lBYIyUUDtTIutrek4bIWUkTbNM/QhyTnZlZQ6
        5Obd4sID6lo0PsMvNVV22KZqeWAOYsTqWA==
X-Google-Smtp-Source: ABdhPJyJLjX+TodkPueY/eNqYbd3bgmPnO8T7vB4DQhWQ4DFmUr3SF6WptFtOs0OjUDnkd9MuvtnUg==
X-Received: by 2002:a92:9ad5:: with SMTP id c82mr9532210ill.225.1605544327400;
        Mon, 16 Nov 2020 08:32:07 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z82sm7029310iof.26.2020.11.16.08.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 08:31:51 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: don't take fs for recvmsg/sendmsg
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <a09e69abbe0382f5842cd0a69e51fab100aa988c.1604754488.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <37ea1503-29c9-da8e-acc6-2b05a70ac34b@kernel.dk>
Date:   Mon, 16 Nov 2020 09:31:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a09e69abbe0382f5842cd0a69e51fab100aa988c.1604754488.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/7/20 6:20 AM, Pavel Begunkov wrote:
> We don't even allow not plain data msg_control, which is disallowed in
> __sys_{send,revb}msg_sock(). So no need in fs for IORING_OP_SENDMSG and
> IORING_OP_RECVMSG. fs->lock is less contanged not as much as before, but
> there are cases that can be, e.g. IOSQE_ASYNC.

Applied, thanks.

-- 
Jens Axboe


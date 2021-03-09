Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517E8333055
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 21:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhCIUzW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 15:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbhCIUzR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 15:55:17 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03E6C06174A
        for <io-uring@vger.kernel.org>; Tue,  9 Mar 2021 12:55:16 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id s1so13428623ilh.12
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 12:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=82eBB3E2DacQoVm2VyMBPmiOYe7OtrPZtkyvzf8UBso=;
        b=NzAEfovl+Bj+96UVUdYcDBMZBvvpZcuehFFKlOV8KeM4IPG+R6Vi/hL4Qqy5ipZJEh
         ez6yxvCTYcOg7aZ60zEBWMpVqDEfG+0c7/DUamDzl76bluM0B4547YyzAOP55jyCBHYx
         qbRutjVFfJm8sU3lwYKqzXMdbpP1dnBof1yTpsRLlpUvaBD+y/2CvxQjIFiIkvAWalRN
         YzcwKuxb3KRrnDIn5fMBZxQmNwzSL/tdy2vbRUzB7Wy2mHYpfj1+98siEVQiNf9XKYM2
         5ABfV9eerLmZ0XBryI39g+dqNSSeLET+6wx7YElpc9+jKi0j01zCkemHz/xDgEcLev3f
         nTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=82eBB3E2DacQoVm2VyMBPmiOYe7OtrPZtkyvzf8UBso=;
        b=DnY3H6E273ilbrXW7cjkjUlWqdZNmgvY0Y1xxwobNysFYdo2Jx1Nv90LOYgeijJUOY
         b+mwtdOIjgQAj8DzPbSbTxvY61xEuzkwB+FzHNYjtkQdaF73w0AvKxCFekHyfu8F18vO
         AN9+B62hmbUQrhzA+C6WPwRR2dRfDXzZj7CX5iK4SJwjyWGaQFH+8vnIw2K4Y8+1hwmo
         Hvbhtpb8AD1JK5sDH2L2HoiicnW7pVW/FZittdR3J1OmZvHYaXpNA7sPHOhYn5j9jZdc
         mzg97+h9WIm4UrkhsrIUigYCi6ZAfvVMb1+bXi9HO0lOrl2W0ruH2RmMHcBy8lE7qsSc
         RVDw==
X-Gm-Message-State: AOAM532eYG5U2HrTnWTH6kNGD9vrqtsfoSaULUQfmZ4SGfrwzpRR51NQ
        g00GIu0/ih7INui1RCqo1IVE5h4vJyihBQ==
X-Google-Smtp-Source: ABdhPJxbuCq4KxLZ9Q6Ss/VRxgbZ6BExPAPA4eT8CzfNeV8q1SvVWsQKp4zUoJy1An73XBVHxuGp9w==
X-Received: by 2002:a92:360a:: with SMTP id d10mr41654ila.198.1615323316465;
        Tue, 09 Mar 2021 12:55:16 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x2sm378067ilv.36.2021.03.09.12.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 12:55:16 -0800 (PST)
Subject: Re: [PATCH] io_uring: remove unneeded variable 'ret'
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1615271441-33649-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0147f7f5-af42-e28c-1b21-723895f8e09e@kernel.dk>
Date:   Tue, 9 Mar 2021 13:55:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1615271441-33649-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/21 11:30 PM, Yang Li wrote:
> Fix the following coccicheck warning:
> ./fs/io_uring.c:8984:5-8: Unneeded variable: "ret". Return "0" on line
> 8998

Applied, thanks.

-- 
Jens Axboe


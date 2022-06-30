Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A4E561AFF
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 15:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbiF3NIR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 09:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiF3NIQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 09:08:16 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CBFD133
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 06:08:15 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d17so18079057pfq.9
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 06:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=XSNoskc8PZTK/w9VBT7F/TRiIswB3Rc2Qe59z7Bpl0s=;
        b=ZLERd8U1mFnuUZSrjD/wqKCAMRUo+HMIXZ1FTzLZepBFhE5jdMdfQmptXOkbRNiw50
         Y3t8gcUtsMsJol7V1sSG1wgDktEM9Gj7mhRhGKWKid9Ee5Ea0/+ipWPLOythdob0eoKF
         eNTO5qpOfA1+gB1O3woF2en3Y3zRaXnY2T1mdsEfyD9k5msLszEHKWWcWRJCa2W5Il6K
         Og0TR2UlRSr5s4Z6c/BXVdnn7vEP+sdOOkNJ54wrWgCuNRXRJvZSITKFHfhmpJaJhyud
         gKl4U74wPj32A29aMSS8CVsS2u0z1JRWdlfHBSk8VFd6AYLVmI3lIqNde8dVaCVr2Phg
         2ULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XSNoskc8PZTK/w9VBT7F/TRiIswB3Rc2Qe59z7Bpl0s=;
        b=SU0XdvxxI3Ot1LaIsMIASPQncMbr6BLYrOSAyxcZj7l/4H98bS+qc6XvvaaouTw7FB
         CdkKbXt7MrsHYSUenBbb3Kd1DWJfjValP0L5fcwMpjloOsM6YKx7AH+QwkidxZcLjycL
         sQ1o+F88DaXTniV4bYjey1TXIDeZq1bUAj3Btr9c7OC+a4Nj48QJ1XsdBAwmIPtMahJ8
         zrr+ecmqeJBcIetlhseb6gi2DDTjz13O9knGiUo5SzOzhzkJ4kBnzM0vqWCUNiYtW35g
         RaX8HWhzqz7wp82j5iN0dgvNJLji7IgAewi3KG3Uo4pBSayaddZYI9yIsie7Uz4Xu9US
         ukHQ==
X-Gm-Message-State: AJIora8bU+HW+XHCX2I+920TO7UB1iJksIplUo9ZLGF5lHi/va45Gr7Q
        GMwr98wY+4LZNGehO5CfVV/XVg==
X-Google-Smtp-Source: AGRyM1spyGJPeRsSmQw5uwlzClJSo/CKQMG2Wvx2yHELSN5Jb4YQAEcVQQyhTn4UGCwbsvVat5Z7Ag==
X-Received: by 2002:a63:d853:0:b0:40d:6ea0:74d6 with SMTP id k19-20020a63d853000000b0040d6ea074d6mr7480154pgj.26.1656594495000;
        Thu, 30 Jun 2022 06:08:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c15-20020a170902c2cf00b0016a268563ecsm13484975pla.23.2022.06.30.06.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 06:08:14 -0700 (PDT)
Message-ID: <0f9b3a48-2f1b-6562-54a7-7e72fc700f1f@kernel.dk>
Date:   Thu, 30 Jun 2022 07:08:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 2/3] alloc range helpers
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1656580293.git.asml.silence@gmail.com>
 <218118e4343c04010e9142e14627a7f580f7bca5.1656580293.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <218118e4343c04010e9142e14627a7f580f7bca5.1656580293.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/22 3:13 AM, Pavel Begunkov wrote:
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  src/include/liburing.h |  3 +++
>  src/register.c         | 14 ++++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index bb2fb87..45b4da0 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -186,6 +186,9 @@ int io_uring_unregister_buf_ring(struct io_uring *ring, int bgid);
>  int io_uring_register_sync_cancel(struct io_uring *ring,
>  				 struct io_uring_sync_cancel_reg *reg);
>  
> +int io_uring_register_file_alloc_range(struct io_uring *ring,
> +					unsigned off, unsigned len);

This should go into liburing.map as well.

-- 
Jens Axboe


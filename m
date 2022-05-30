Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42090537B3D
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 15:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiE3NSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 09:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiE3NSs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 09:18:48 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6737A54FAF
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 06:18:47 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y199so10554148pfb.9
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 06:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xujx51KQQyEhIr4khHKkYG5RKraGKk4TKu3VtsDzKA0=;
        b=4nRLR7JrX1KiK57lsELzjXfoj8U7l3KRtZ79q3mdtPtBsd2aTG4tRiSa4et9N9sLtM
         DCa/mNCRZLC2R6dUHfS2Lel7gXx6+jwGXe4MdB9Y9sKH31OgFOmRUVf/2JRXAz16gu5S
         LtddlqerKB5pePgPD3cSReyrUfvGh0cglpRxzKSlVp7QjghCBhRv09eAJkICadGAbxP0
         +jJtecpmR9H2yWbRC5WSYChC7ZydLEblAqaL5D70kv20CKIznkm1xKTo37tea/FPj/rF
         KGSPr0r7/6W6X8v5FIs0xgLk8uU0osYz3KpURCMwPxkO88VG4+192AjnbHcxzm/szUPE
         JjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xujx51KQQyEhIr4khHKkYG5RKraGKk4TKu3VtsDzKA0=;
        b=Y3ICKYlw2zTuXHugyoFwhH7K0G8miL0FGwDuLQePiBqZOzVtV1HXE6gb2n+rkYjvMe
         CnJ3TlI95UnKpbygJKZiR9IbTmJWiG/1tgviv0OKoS0ekNruNOcvKgQnkuMFhJKoFuHY
         +p6hEQzlk/0rCmJby0r2Cu/ryeXGUqae5Q9Z4g5PU1Ombe3gZyy1Uh1n/N2ftGKxwyBf
         7GxR55EbJPevn9RphaCfcCH0Uq/n6RetIdv0BvF/H0B3fnAwGcRDwBWvJRFMANktiNSu
         Fs6Su2lavYrpK/ML2Af1YxJWhWj8ZQQLv+3H3mvBQtVYAjkcKiS6Gr7KV95DO+yqCKVG
         aseQ==
X-Gm-Message-State: AOAM532aYQtRhDlen2GRS11b07mY5SVs+5ZgFLOhhyjdT8sflQiLRPdX
        sey1gKhWk/kvI851uPqGu9qsOw==
X-Google-Smtp-Source: ABdhPJzx/Pp1YPXt+/VdKhP3Q7Ta+v4Sy+WCdWQm1ah/LdZ/5C+fCVUhjiOKHpbRu5ocvYAbVAMNjw==
X-Received: by 2002:a05:6a00:2187:b0:50c:ef4d:ef3b with SMTP id h7-20020a056a00218700b0050cef4def3bmr55869398pfi.83.1653916726884;
        Mon, 30 May 2022 06:18:46 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o13-20020a17090a4b4d00b001df264610c4sm16665638pjl.0.2022.05.30.06.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 06:18:46 -0700 (PDT)
Message-ID: <3064f1e4-c66b-a90b-8073-dc63525c5aca@kernel.dk>
Date:   Mon, 30 May 2022 07:18:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220530131520.47712-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220530131520.47712-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 7:15 AM, Xiaoguang Wang wrote:
> @@ -5945,16 +5948,22 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
>  	return 0;
>  }
>  
> +#define IORING_CLOSE_FD_AND_FILE_SLOT 1
> +

This should go into uapi/linux/io_uring.h - I'll just move it, no need
for a v3 for that. Test case should add it too.


-- 
Jens Axboe


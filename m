Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B01F7AB5E4
	for <lists+io-uring@lfdr.de>; Fri, 22 Sep 2023 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjIVQ3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Sep 2023 12:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjIVQ3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Sep 2023 12:29:53 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FEE139
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 09:29:47 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-79f96830e4dso18307639f.1
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 09:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695400187; x=1696004987; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zfu9KE5FyBSR/O0z5XFbdb72LTChkuBOU7sWNPErj8o=;
        b=n63qYiK5V4QR/q7az1dgpmD/qIXGx8a/H9hzETByE8t9YumIIgMhYx3rXOP4tPJZkS
         sIMh4ZOUE79lXh8TZQtMDrS+R9xt3vvqFUGG1Zc2wgpNrQFThYVsY/hpBqEPKs7kpEkf
         Z3OdR7hhKpQp3p27YGotYxxprsW6amP1u6O/frB1HDXHPh4bPkTPPCn/q4U9MtfneUyF
         0DiOriTcbAznlyW1wW9jMDn9UoGivbEeSFmocyNdKlaF+v40bGq5HGcYCJgs4b+jOKth
         dN7jLRgvgTdlRwv9+mLbb4CKVpt3zDT6xHqDrir3wJufpAezbnK3zXJWw54L1QR/Y0ab
         4Chw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695400187; x=1696004987;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zfu9KE5FyBSR/O0z5XFbdb72LTChkuBOU7sWNPErj8o=;
        b=ENkEmsXsLsNiHz+Mv4icsOC+NSNqxuLvPFiSl+V7H4lnI7iqjhN63CKQfJ2TcxlYyU
         5wQ5pk+C+QqUtL3Us+g2iSJBbASAr0Hk9UqQZkEymMym4DkX0FBh2XryOqw9UTqKn+41
         D2+CV/nNd6HhoqNApOsnSql6/eheOUbAmHCKgYrvh/6We2Nn5rlWf5StpdPXMlD1HVcB
         hd64kMCBfbNcVcJFIexIjrhAL0N6M55S6V2FXkogecoErHlhNPqxZZ02vTg+RPW7umAi
         KcEvvGjxs4i/i59TQ7bzwZtl4yWiv4J8cxSjxLzKN0Enp2RNAGp4xi/oaY3+3r4FxAFf
         D6eg==
X-Gm-Message-State: AOJu0Yz1bY4fqcCdRcVmWRg+Mfeg6/A1STtfH3Tly2lDObFvv+eRTdha
        1coYYBY59k3J+jrHPm2xnI8JZmTOeqY5+RMzpLhkew==
X-Google-Smtp-Source: AGHT+IETFS7NSB77Epw9pCJRfzzcjSErqPf7DJpjKsBH210dkfHQIxbcFoSHOl1u7D3jmeMR4wU/sQ==
X-Received: by 2002:a05:6602:3788:b0:792:7c78:55be with SMTP id be8-20020a056602378800b007927c7855bemr9272371iob.0.1695400187350;
        Fri, 22 Sep 2023 09:29:47 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n18-20020a056638121200b0042b0ce92dddsm1055745jas.161.2023.09.22.09.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 09:29:46 -0700 (PDT)
Message-ID: <0df2790b-1122-40a5-9bfb-3da6048c24ff@kernel.dk>
Date:   Fri, 22 Sep 2023 10:29:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/2] io_uring: retain top 8bits of uring_cmd flags for
 kernel internal use
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>
References: <20230922160943.2793779-1-ming.lei@redhat.com>
 <20230922160943.2793779-2-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230922160943.2793779-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/22/23 10:09 AM, Ming Lei wrote:
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 537795fddc87..52a455b67163 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -90,7 +90,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	if (sqe->__pad1)
>  		return -EINVAL;
>  
> -	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
> +	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags) & IORING_URING_CMD_MASK;
>  	if (ioucmd->flags & ~IORING_URING_CMD_FIXED)
>  		return -EINVAL;
>  

Do we want to mask it here? If any of the upper bits are set at prep
time, that should be an EINVAL condition.

-- 
Jens Axboe


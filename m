Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC10F58AE96
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 19:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbiHEREC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 13:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiHEREB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 13:04:01 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6BE6E89A
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 10:03:59 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id p10so1647457ile.5
        for <io-uring@vger.kernel.org>; Fri, 05 Aug 2022 10:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=3nQ1rVXLpDSEFDUYuvx5YwgSl2ilKx7UDUIcTLmdIuo=;
        b=G4ApnmUZDgpX2DJmLdTVMAJs8qbQzm92gbUQFUaXmWPNDuJ1O/43ntQr630qbpH2FN
         VemYqANkxAxoNDvqRwXnNv+d0P0IEFfxMsYHwTYbJ2PmJMcHAc3kYQ5DMUI6U5nWjbn0
         GfWksrjiw2cVYPX+7ApGFWdgKqb53JNYuTHuPp2YuIKD6Bp6DhoI5UAU6lAR+CnH3Pvm
         x0pKJ7yLKvuawC37VPBNaMRf1IoCIeNYIGwfZ5KRb5pmMhGAEjP/wbEoek3qUCiHIn/A
         OHdX6D5X0+QZfrTZRVEHQLaELAnauH4pLqGiMcDIhiut35i8efoEwES6yuHJdRhxBnSd
         gETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=3nQ1rVXLpDSEFDUYuvx5YwgSl2ilKx7UDUIcTLmdIuo=;
        b=r8d4OrSHF7Xn3UT8ZEyKWjFbvZIoadUyHuvGV9mZ0CkVTAsft6jW7u+1Awft3Oiq+v
         u7NfQZ2AibLIsGhzzBgb1bS5JA1jkc6cRPjv+8EeOe7fg4Q88BvynxpM39CojhoY7mGO
         9EHYzFPeocQmge42qLG8RqLzwKl0ECprVfS2Q2SWpiW5tF6Q3xh6isr2GH0M/u5xgKHy
         pQMNAZcaC7W5k/2iRD+uPbZxcB0QRcmclMcQMBx5Tf5PAMtcAiH/X9fXJT5yAESgoRa2
         fRm0IwjeJI+rUSsMB27aVOxwozcId0g2EhzWnwUSw1G7AKHFbbi8DX8wfUN1g02BqfPI
         eeEA==
X-Gm-Message-State: ACgBeo21YJSYPhLnrTOYZHW9KOOXL4lWHL53pLYobdhsFygKW1Kd8+9A
        Pcz514FSFQC+LZUSPG1aFpmOxg==
X-Google-Smtp-Source: AA6agR5xQA3di+F1B3DmrrgTAxXjfGE66ys1tZEHESkOge6dBVCelgqekLGqKnaWIx8jpVB/c/uRjA==
X-Received: by 2002:a05:6e02:b26:b0:2de:b192:9dfc with SMTP id e6-20020a056e020b2600b002deb1929dfcmr3612125ilu.273.1659719038985;
        Fri, 05 Aug 2022 10:03:58 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n16-20020a056602341000b0067ff1354b46sm2041257ioz.39.2022.08.05.10.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 10:03:57 -0700 (PDT)
Message-ID: <769524f5-c725-85f7-e7ac-ca3b2b2d884e@kernel.dk>
Date:   Fri, 5 Aug 2022 11:03:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 4/4] nvme: wire up async polling for io passthrough
 commands
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220805154226.155008-1-joshi.k@samsung.com>
 <CGME20220805155313epcas5p2d35d22831bd07ef33fbdc28bd99ae1d0@epcas5p2.samsung.com>
 <20220805154226.155008-5-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220805154226.155008-5-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/5/22 9:42 AM, Kanchan Joshi wrote:
> @@ -685,6 +721,29 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
>  	srcu_read_unlock(&head->srcu, srcu_idx);
>  	return ret;
>  }
> +
> +int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
> +{
> +	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
> +	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
> +	int srcu_idx = srcu_read_lock(&head->srcu);
> +	struct nvme_ns *ns = nvme_find_path(head);
> +	struct bio *bio;
> +	int ret = 0;
> +	struct request_queue *q;
> +
> +	if (ns) {
> +		rcu_read_lock();
> +		bio = READ_ONCE(ioucmd->private);
> +		q = ns->queue;
> +		if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio
> +				&& bio->bi_bdev)
> +			ret = bio_poll(bio, 0, 0);
> +		rcu_read_unlock();
> +	}
> +	srcu_read_unlock(&head->srcu, srcu_idx);
> +	return ret;
> +}
>  #endif /* CONFIG_NVME_MULTIPATH */

Looks like that READ_ONCE() should be:

	bio = READ_ONCE(ioucmd->cookie);

?

-- 
Jens Axboe


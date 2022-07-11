Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5BF57089E
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 19:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiGKRA5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 13:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGKRA5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 13:00:57 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B62C248FA;
        Mon, 11 Jul 2022 10:00:56 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id n185so3382649wmn.4;
        Mon, 11 Jul 2022 10:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oRVmx9bOllxl3kVjulrN4qiEWyIXLjdDXqd2F2vjPHA=;
        b=J3j1vZwpPz5WJUe9EVOv5OWPcqv0klsvEYePqqxee9pK7CR2WIpF5WWP3flT7QJu6j
         IXkPjKaLpA2oovTPOgLKjGVrSrYq6e3G85X+V6Wt//y3n3VBXeDW/zy4ufAosy4cppZJ
         poXKdnp0kBNHyyOizfeVkqX1di525PeZh/Yq2isLGk4WD/M3uDzuyVy3NHtGS+DGzRPJ
         mZkM4WpqXjyUf+45flyR+Gy0r1cdDGkTRvh0eyPVzOoAzaY2faxb15xf6Q0uJaMSvYsP
         mIFbUQPFxMEWrlIr39/b+o66nc5vlrg4vr/2QuVRVMIgLXZ+Mz7xz5YTGIfSptKI2cNb
         QmUQ==
X-Gm-Message-State: AJIora9/XigAEIww1JGILwdyBNbAenbri4R6cm3wTP2/SL8HcP8s/idI
        udqHED3ke63W3qSwKKOWuSuccZUShhM=
X-Google-Smtp-Source: AGRyM1vg+hOt68iw5r4yo5w1HrJm0Q9QpaeugSVcQ4WGNMMLtUlEwXoj/U8a580os9JSwUfwsq3fiw==
X-Received: by 2002:a05:600c:1548:b0:3a1:95fc:aa42 with SMTP id f8-20020a05600c154800b003a195fcaa42mr16914667wmg.189.1657558855078;
        Mon, 11 Jul 2022 10:00:55 -0700 (PDT)
Received: from [10.100.102.14] (46-117-125-14.bb.netvision.net.il. [46.117.125.14])
        by smtp.gmail.com with ESMTPSA id r3-20020adfe683000000b0021b81855c1csm7411785wrm.27.2022.07.11.10.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 10:00:54 -0700 (PDT)
Message-ID: <11db8ab2-b41a-967e-8653-7a84b8a984c0@grimberg.me>
Date:   Mon, 11 Jul 2022 20:00:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 3/4] io_uring: grow a field in struct
 io_uring_cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, kbusch@kernel.org,
        axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b@epcas5p2.samsung.com>
 <20220711110155.649153-4-joshi.k@samsung.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220711110155.649153-4-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> Use the leftover space to carve 'next' field that enables linking of
> io_uring_cmd structs. Also introduce a list head and few helpers.
> 
> This is in preparation to support nvme-mulitpath, allowing multiple
> uring passthrough commands to be queued.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>   include/linux/io_uring.h | 38 ++++++++++++++++++++++++++++++++++++--
>   1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 54063d67506b..d734599cbcd7 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -22,9 +22,14 @@ struct io_uring_cmd {
>   	const void	*cmd;
>   	/* callback to defer completions to task context */
>   	void (*task_work_cb)(struct io_uring_cmd *cmd);
> +	struct io_uring_cmd	*next;
>   	u32		cmd_op;
> -	u32		pad;
> -	u8		pdu[32]; /* available inline for free use */
> +	u8		pdu[28]; /* available inline for free use */
> +};

I think io_uring_cmd will at some point become two cachelines and may
not be worth the effort to limit a pdu to 28 bytes...

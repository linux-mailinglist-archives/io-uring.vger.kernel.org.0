Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DB15AD8A2
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 19:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiIERzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 13:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbiIERxo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 13:53:44 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436256052A
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 10:53:43 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso4267751pjd.4
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=zeGc0vwJDgBIJyeNrQDrz976x5n1fo0aH2VcrMu6kPU=;
        b=3TzLFPJsgQVoyzIEgelyj96PTJ9RA2qoPFKMvnvgNEGKK3Xg7EfO0JMiwAXt32iElf
         vfYSQMKS+7btTv0zYBL+JqK4B164T+u6A4q65qijRqZyjFwAkIJp873GODXmEqUbmCCl
         a4PU+gLa9IJVBoluV1WyE8I2Zq7+YUslviqLsKLMihwruNHwSorxpHp+7VzMqUYi3TBx
         YFyW7ALBsYtKGUQT/cNuSBySGtF5RFshRyz4JQlfcDDqnfeOdKj2rIW3G6/Iq+Iicinq
         dqOHLOCjuAfw7X/gYLQhSZJIUxQsokZNds8p706H8863+sWLzEVugxnU1gj8eVaU8mZ3
         4+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zeGc0vwJDgBIJyeNrQDrz976x5n1fo0aH2VcrMu6kPU=;
        b=uTr60EqxMwAsegwgptjj+e+Fio0xK5IyYLpemtxIXZM3eC9EJgQSpKZIFozNgWb/NG
         NBDiY3VIcrBydvdEGVZPcgcez5MYxxuSgKuv3KYfYdenzkmQmUn5wKsHwo5y+ySTOnno
         6gtwFeEUAHNT4Mhf5oom3rxkVORwE9lvvcj6w34/a37Zpig1qqKkjUKRF3awkJfKctlg
         ssWPhqia4hjP8N404PC8E4So/knGJBi6Mu6eH2i8yvi1MLDDjUUHRPhh600XEybEZ+X7
         DG/eVQL7Rmg6pxlKOODacfZad/HHlvniWFY9Ev3OZG+BE/sqwV8XkyGPmLc96V5M+X+n
         XYlA==
X-Gm-Message-State: ACgBeo2RSpja3gU2yxYAVWYcQ76U6fwfQPJDgLXKD01XyodyCoidMQM5
        clGpL3GBzCkwe37O2c8j0rwnPw==
X-Google-Smtp-Source: AA6agR7DiMNf6wfT4ZoG5rsHUmL/ehmUhw+ETrtpWSzJRoiOawk/VgiGVH9Vb1lT8IaVGei10sbUSg==
X-Received: by 2002:a17:902:e848:b0:176:c746:1f69 with SMTP id t8-20020a170902e84800b00176c7461f69mr1501581plg.125.1662400422716;
        Mon, 05 Sep 2022 10:53:42 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u67-20020a626046000000b00537e1b30793sm8331899pfb.11.2022.09.05.10.53.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 10:53:42 -0700 (PDT)
Message-ID: <5a0f98a5-8710-0719-91e6-e75af1818b1b@kernel.dk>
Date:   Mon, 5 Sep 2022 11:53:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH for-next v4 1/4] io_uring: introduce
 io_uring_cmd_import_fixed
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220905134833.6387-1-joshi.k@samsung.com>
 <CGME20220905135846epcas5p4fde0fc96442adc3cf11319375ba2596b@epcas5p4.samsung.com>
 <20220905134833.6387-2-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220905134833.6387-2-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/22 7:48 AM, Kanchan Joshi wrote:
> @@ -124,3 +125,13 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  
>  	return IOU_ISSUE_SKIP_COMPLETE;
>  }
> +
> +int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,
> +		int rw, struct iov_iter *iter, void *ioucmd)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +	struct io_mapped_ubuf *imu = req->imu;
> +
> +	return io_import_fixed(rw, iter, imu, ubuf, len);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);

Oh, and since we're probably respinning this one anyway, I'd do:

int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
			      struct iov_iter *iter, void *ioucmd)
{
	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);

	return io_import_fixed(rw, iter, req->imu, ubuf, len);
}
EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);

to both fix the indentation and get rid of the 'imu' variable that isn't
really necessary.

-- 
Jens Axboe

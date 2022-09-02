Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9425ABB11
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 01:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiIBXNp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 19:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIBXNf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 19:13:35 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D637F8F53
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 16:13:34 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id z9-20020a17090a468900b001ffff693b27so2081698pjf.2
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 16:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=CXSB5TwQbhvqvewpZ+yLTD4zJlq0TXQvGw/arvh5s4I=;
        b=ydYkR1iRxIzyhVhT6ccZmKXT8Qn8AKHxRsc+Ure00NiYxb45RSanHnq/6xmpSiqXLh
         WjKbAXViH3J8OqdcKTBpOAB4+81FRqfJNIdAXpQH1wxoJEXQNtbL9ZbZr/cC/tu9LIEi
         a4ep0wmMZBQv+w16n4R+mot2yZSZ0+koUZunuvHTOv53RJbiNrrUnmPjcoe8TIN9Zk2y
         YfdlLS4daLj7Lv1RX5dGb2evckuypxQRbZsD1uto9Q/wrSL69HUaPW46aP93RoV80KDA
         6KRIjpfqeL2fC4xTr1HnbhXHTwMDq3K3o+u9dUW3iu0lgltHGkGZC/xtpC2GeCD2ZuAN
         VasA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=CXSB5TwQbhvqvewpZ+yLTD4zJlq0TXQvGw/arvh5s4I=;
        b=cla1ueNJpQa310wjBEBZZncGHmsq9T1Zt5Go64Twxy+kt4ERc/aFq/8uVpMskjNnq8
         gYDfiE49tYJjHX0RmistFTi/qctcm3nhayxSqstp6CL1WPFLnpJ9KQ4crCoTBQeRx2UP
         CcCcrqK1nlla6VixNKgVKIvJqjDy3GxGvXJfOo6HZHl8QcwFcnTDMDHWLBYoKLUVvH6I
         r0rGT36VKNC0oPH4gDunpevQZ3F9H4oF7ok+Vx4nvY7vWiBZntIFRowrMHoUn3AJGS1N
         N2Bf2ao/K3EOMCKYa8xGYJTiDcIORhhcHFpUEZwUMSnDNxuCc+NDrx9lQiDBJZnNbnCd
         V8jA==
X-Gm-Message-State: ACgBeo3gtsxPced+UGzgBZKcf7gM6p+21Nu9dgzAk+leRGVwUze4RNUp
        8gHftXO3hVwo/bURq4Q3Kem5Ug==
X-Google-Smtp-Source: AA6agR76BTTkq043ixjnj0rmLmscN3HwyukynuCP9i23k3WkPxF7v9Fg7NyV/p1llvEwU516/dBXpg==
X-Received: by 2002:a17:90a:ec05:b0:1fd:9368:2c8 with SMTP id l5-20020a17090aec0500b001fd936802c8mr7215591pjy.183.1662160413809;
        Fri, 02 Sep 2022 16:13:33 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j8-20020a170903024800b001754cfb5e21sm2243630plh.96.2022.09.02.16.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 16:13:33 -0700 (PDT)
Message-ID: <71945cbe-fe10-2d53-5df7-9f7e6f88a905@kernel.dk>
Date:   Fri, 2 Sep 2022 17:13:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH for-next v3 2/4] io_uring: introduce fixed buffer support
 for io_uring_cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220902151657.10766-1-joshi.k@samsung.com>
 <CGME20220902152709epcas5p1a1bd433cac6040c492e347edae484ca5@epcas5p1.samsung.com>
 <20220902151657.10766-3-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220902151657.10766-3-joshi.k@samsung.com>
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

On 9/2/22 9:16 AM, Kanchan Joshi wrote:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 48e5c70e0baf..c80ce6912d8d 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -56,6 +56,7 @@ struct io_uring_sqe {
>  		__u32		hardlink_flags;
>  		__u32		xattr_flags;
>  		__u32		msg_ring_flags;
> +		__u16		uring_cmd_flags;
>  	};

I don't think there's any point to making that a u16, let's just make it
a u32 since the rest of the flags are like that.

Rest looks good.

-- 
Jens Axboe

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A795EAB9E
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbiIZPua (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbiIZPuN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:50:13 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBA160528
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:37:20 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id p202so5368554iod.6
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=t0MUrMBj5+/gRsFYgcIoA4365ly49QGyxJn+jkq+0WE=;
        b=lRVV8RbtlTFtYfETYhRRYkcmL7X4/LvN2rrSp2wC+6TV4Va0nakB4Zt7BtxaP8O83j
         TCH6vyC0VLGPUAtqzP5Suk64ba+4yT4WEQ0+NKxWCFFTAtDYv7n56lKwO563vpp4aEPh
         ax9okyFxsTOUjcmFFHAb+fsh+gQRThfHBf5/b0eRd+9HPn6skUwlsUsmwK7+PwlJx9tZ
         9I+37qvNL3/5QLqH43wY7YlCJtFPFc6mMfrjPR01zYIS/4x3UDe2AbK+HKf3J3m0WUoV
         YqO1hJ5Z6SokeP0R84QTgNWxCmqWQ8uDKGngWpnefrcxNhPXL+Dt/piHRw2AN1JqZCxm
         4K0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=t0MUrMBj5+/gRsFYgcIoA4365ly49QGyxJn+jkq+0WE=;
        b=jLkNggKGF9EfUYcllnMUVGCu1guKaQ1rDFiqAgdF6o8MwY2wDS1ZrPA/yCkiSwqiNW
         buoI+kMlifqgwxJ7OBJIp8gf17OErkfnKAAAhf32K0R4elkg27ZWQtAXiygPOEFRfQ1I
         zgWDUIIIOlkr88CHJmFUGm6zgRfyUvSTs8nc9cnPcF/xjy6QP2D7Uui0Ga/BFf+6Ef9l
         RFdnGO2j5Jrh/cAslTz2qGyioYNIkKFew7XlX7c6/Rsv4mrycer6iJnwMkFstrIQu3T2
         P2+L9JwiO3cMdUR8MPkceban//JLkSM+Ae3lVopqkqP1MOyYr/r56eNwceEw56noKcgB
         miPg==
X-Gm-Message-State: ACrzQf22sENEs5WXZoS0mZGQKYQ0OV5CasYKbs27Z4M077IpxvaYNkvb
        qDaVN88+MRyawL8jDyJeBjK5Xg==
X-Google-Smtp-Source: AMsMyM64l3/OBIHCixHdoBxYVdcJiOzW5N88/JdLYTiC45vxft5D6aOHFJt1mBJ6pKzQR6VdVZiOoQ==
X-Received: by 2002:a05:6638:2612:b0:35a:337a:8a4c with SMTP id m18-20020a056638261200b0035a337a8a4cmr12496698jat.269.1664203039836;
        Mon, 26 Sep 2022 07:37:19 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a12-20020a92444c000000b002e11d365ccesm5891918ilm.80.2022.09.26.07.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 07:37:19 -0700 (PDT)
Message-ID: <a14671e9-4963-21db-3b48-1d4cb2130e65@kernel.dk>
Date:   Mon, 26 Sep 2022 08:37:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-next 1/1] io_uring/net: fix cleanup double free
 free_iov init
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
References: <f159b763c92ef80496ee6e33457b460f41d88651.1664199279.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f159b763c92ef80496ee6e33457b460f41d88651.1664199279.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/22 7:35 AM, Pavel Begunkov wrote:
> Having ->async_data doesn't mean it's initialised and previously we vere
> relying on setting F_CLEANUP at the right moment. With zc sendmsg
> though, we set F_CLEANUP early in prep when we alloc a notif and so we
> may allocate async_data, fail in copy_msg_hdr() leaving
> struct io_async_msghdr not initialised correctly but with F_CLEANUP
> set, which causes a ->free_iov double free and probably other nastiness.
> 
> Always initialise ->free_iov. Also, now it might point to fast_iov when
> fails, so avoid freeing it during cleanups.

APplied, thanks.

-- 
Jens Axboe



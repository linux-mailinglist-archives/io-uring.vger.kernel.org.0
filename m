Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC8D57D073
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 17:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiGUP7p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 11:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGUP7o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 11:59:44 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E727E334
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:59:44 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id w16so1026792ilh.0
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OsBoCKDjfeknAXU3dKsCB3uQsUfKOh/BkqW1nBp0ygw=;
        b=bW94iTEYmDPiT9LeN+N/1NZrYCSVfpKngH+SMLW1Qhy2abKOfBTjjs5r8VONogymtO
         zAhEWLChFp4IyQhTFz3QGgWGHYet/ui0IvylnGeisRM1f0H6I6k2XIDulA9docgWAMv9
         32cP91srohh6Z0DlWrrmgfC0Ys1T8SeClx9z9YGooHPL806mlHpEduvfMujSTEpIztSz
         Ui5cgAsOJUVdimKl64xPJZIJaKFTRZVo8ANdrQoaVqqLe953Ti8qgpAjG7VEX4XRm9GE
         Zuh5o8ZLjbn9fQtszHUuiiPcTi2Nfe7JpMvEXe45LwRKKjJnMvqTXempnZMP8nPM2G0E
         bcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OsBoCKDjfeknAXU3dKsCB3uQsUfKOh/BkqW1nBp0ygw=;
        b=vNiqXCJmhxqHeOGuoZ46z2/3bRq8G43vDN/+xnMuVMUgl8r8mqFrFlUWL6pqsu1p5p
         cSHmwHj7TcYH/f0BR4cNfLM1RCuznRN8Q/2Xj5Qp5fOFl5BSo8l9ySrIPrhJ4H3Tqp25
         ZadTAGV0FW1Ve7WiKFA1mq/jy9Y8BMlFCySv/JK3kZKqIlXf4zb+y7WHNdXiivyF1/Yj
         jiyAgzDgxW9Ju03EMihyYpQ/fDPdXEqi+Tt8iLro94QhpU5Kcux5Z9NGupzmokhlFcnS
         JFy0eOadDbv3bdxgq4ZTLXM8c9F0GSpu+bZlYiYmXErRtwITgLunYofPzhp5/sIYG4jh
         dmsw==
X-Gm-Message-State: AJIora+DsfPLX1NyeWlXIWQGsEaVsUqEnil825bEGrpfgFxeD7sa8bTP
        cGzAlBCA8VwYnlu9ZJLZ5Ed44I9WYS43yg==
X-Google-Smtp-Source: AGRyM1ssCEch9yja1xHY1LUgo2exKJuqQUE4bAUNk4UsiDdxL/rXR1PWXHpdeQzvku8RjleqGJL5wA==
X-Received: by 2002:a05:6e02:2145:b0:2dc:8548:ad90 with SMTP id d5-20020a056e02214500b002dc8548ad90mr22435653ilv.147.1658419183358;
        Thu, 21 Jul 2022 08:59:43 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z30-20020a0293a1000000b0033f043929fbsm923600jah.107.2022.07.21.08.59.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 08:59:43 -0700 (PDT)
Message-ID: <62207ded-7bf8-9aa1-bfc0-90a0aa12c373@kernel.dk>
Date:   Thu, 21 Jul 2022 09:59:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: __io_file_supports_nowait for regular files
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org
References: <20220721153740.GA5900@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220721153740.GA5900@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/22 9:37 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> is there any good reason __io_file_supports_nowait checks the
> blk_queue_nowait flag for regular files?  The FMODE_NOWAIT is set
> for regular files that support nowait I/O, and should be all that
> is needed.  Even with a block device that does not nonblocking
> I/O some thing like reading from the page cache can be done
> non-blocking.

Nope, we can probably kill that check then. Want to send a patch?

-- 
Jens Axboe


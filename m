Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F165AB594
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 17:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237115AbiIBPqt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 11:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbiIBPq3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 11:46:29 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A1B2DE6
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 08:35:08 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r141so1915781iod.4
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 08:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=kmWx6GQdEOtF/uL3thdhLU+yeJiJgGxBRHmkDdY8oDM=;
        b=u022k6EYXiOXMch99qyEGcZPDNWmlAKj0DNCn+w1cCZ1xdp4kimxRT8y3JB6kTXXlu
         dJo1S3YC7adSKZULoccPxd/74sppKhrenMLOSlqKR7V//ezSBTsQSZOFsLUhCxXFxcSR
         b8krgNQFz+GYhd+MnQAN1zJ9CfU6vp+uecvw604ydbfuULNwxQC+fUrnVy22Vgbod+Tz
         ZPMCX/M7xo2odcW06zRyET9u7dAaWHMw9pS2mXqYGngdoAuSkPEBztjWYyv3LDp/TYvw
         0J5S3AmLE0BA7OAdA0JM9ySULTOK7k+fSmc5cKMP3F+L4vOAo3/WKAOKeOuzXrUqppei
         L3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=kmWx6GQdEOtF/uL3thdhLU+yeJiJgGxBRHmkDdY8oDM=;
        b=bucruWbYtlOP4d9hjQP/EbfpI66D87Vsfz83oCrNkFpQmPJ1hCTW03aIf1GABpMV6+
         RoT0LuwlE0fZOxX8y5VzkR1daPZu/Svn64U/jhGDeF4TljCEJ6L+PubP8XTrzUczvvEB
         cf1MydVgqoy7tyhrZkwPw1K0lrHgAzvGQHAq4rD/RragGb2ya1mTPeFG9R63oFumsZQK
         BzXYMKkPrhKfWddhAb5w9acGM02PQsjEYE23/CaxAbcKCBlys5cZX6cAzOfSx2BLbjYO
         A/NKf72tPB9kebiKYe9YpTv+qm9fUb4uhkYoenT3wruWr92/w0wo8dbGvO4wO+JB4AlS
         6/pA==
X-Gm-Message-State: ACgBeo3v0SDe9CCrqYpyCx4eJQCJtcdV45j3lq/EtI7PfqhCKg3YssIp
        kIRO53WL0uRa4MGfI50P85Vz6A==
X-Google-Smtp-Source: AA6agR7vi1T5kgnb2NiyyRAj3pUZQ0IJrIIFQrve79mFhm3NWuLo63V9wBE9wZcZmYId2u5+g2bnsg==
X-Received: by 2002:a6b:ba44:0:b0:688:876b:61c6 with SMTP id k65-20020a6bba44000000b00688876b61c6mr17159855iof.51.1662132907624;
        Fri, 02 Sep 2022 08:35:07 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i3-20020a02ca03000000b00349eece079dsm946495jak.35.2022.09.02.08.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 08:35:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     kbusch@kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        asml.silence@gmail.com, hch@lst.de
Cc:     gost.dev@samsung.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, ming.lei@redhat.com,
        linux-block@vger.kernel.org
In-Reply-To: <20220823161443.49436-1-joshi.k@samsung.com>
References: <CGME20220823162504epcas5p22a67e394c0fe1f563432b2f411b2fad3@epcas5p2.samsung.com>
 <20220823161443.49436-1-joshi.k@samsung.com>
Subject: Re: [PATCH for-next v3 0/4] iopoll support for io_uring/nvme
Message-Id: <166213290569.98725.590739918203033888.b4-ty@kernel.dk>
Date:   Fri, 02 Sep 2022 09:35:05 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 23 Aug 2022 21:44:39 +0530, Kanchan Joshi wrote:
> Series enables async polling on io_uring command, and nvme passthrough
> (for io-commands) is wired up to leverage that.
> This gives nice IOPS hike (even 100% at times) particularly on lower
> queue-depths.
> 
> Changes since v2:
> - rebase against for-next (which now has bio-cache that can operate on
>   polled passthrough IO)
> - bit of rewording in commit description
> 
> [...]

Applied, thanks!

[1/4] fs: add file_operations->uring_cmd_iopoll
      commit: acdb4c6b62aa229c14a57422e4effab233b2c455
[2/4] io_uring: add iopoll infrastructure for io_uring_cmd
      commit: 585cee108ddaa8893611f95611e32ed605fc6936
[3/4] block: export blk_rq_is_poll
      commit: 2dd9d642edf01043885cefeaaa06d9c8e1aa4503
[4/4] nvme: wire up async polling for io passthrough commands
      commit: 5760ebead11801cdb73cdf3841e73231968f6af4

Best regards,
-- 
Jens Axboe



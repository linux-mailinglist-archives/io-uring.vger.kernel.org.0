Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53614572713
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 22:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiGLUOQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 16:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbiGLUOG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 16:14:06 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED1ABFACF;
        Tue, 12 Jul 2022 13:14:01 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id v16so12671233wrd.13;
        Tue, 12 Jul 2022 13:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i44WgiLhEQpL2L8I1eN0xvDidyFTyh3H4rXwJnmjusA=;
        b=PBBtHg+mydX9pqMw1SnRPPN8lgFO1vpOouvEBLhbaWOr3G/UA+g/xk3Jr8E0VKCV7G
         VmcAKDC0JkNA6LeJD2SnsdQqvRfQrfR5rH2xV3vz2KkwvE62JZJs9zU51Y3FYfekuHpn
         yPSDRMmLDPErj5jke37+Vt2EkeOl155jHjUxHrOLRVSsn2eOf+mh29SuJC4JJyiIHXlW
         eWR0+iIZ4MPtPkSZ7dAX17jU43GzfZBjF8ThifkDAq9OykQhm8vUE0XhbwKN4+8+2cin
         RZMfwNcJRIVLHLVqs60rJIO58saoVJHO/n2L8naULt2FaI/ODPYcJpYWhGTeGIAwW8nE
         7E0g==
X-Gm-Message-State: AJIora8LsKoYu+461q/zem3vOsBBy4hcoGZGwp7jyjzs80CSk6n7XhsT
        1Z3OGkVbWs7r46FHU+L5k7k=
X-Google-Smtp-Source: AGRyM1s2AXD5tSZHdhk70dkHduOPy8P8nujvoI7SI2uNkAjYundFhC3fqCftHzf55G2bv5Dopht+9w==
X-Received: by 2002:adf:facc:0:b0:21d:8c8f:4b51 with SMTP id a12-20020adffacc000000b0021d8c8f4b51mr23123290wrs.307.1657656839604;
        Tue, 12 Jul 2022 13:13:59 -0700 (PDT)
Received: from [10.100.102.14] (46-117-125-14.bb.netvision.net.il. [46.117.125.14])
        by smtp.gmail.com with ESMTPSA id q6-20020a1cf306000000b003a033177655sm13617110wmq.29.2022.07.12.13.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 13:13:59 -0700 (PDT)
Message-ID: <436c8875-5a99-4328-80ac-6a5aef7f16f4@grimberg.me>
Date:   Tue, 12 Jul 2022 23:13:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     kbusch@kernel.org, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
 <20220711110155.649153-5-joshi.k@samsung.com> <20220712065250.GA6574@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220712065250.GA6574@lst.de>
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


> Hmm, I'm a little confused on what this is trying to archive.
> 
> The io_uring passthrough already does support multipathing, it picks
> an available path in nvme_ns_head_chr_uring_cmd and uses that.
> 
> What this does is adding support for requeing on failure or the
> lack of an available path.  Which very strongly is against our
> passthrough philosophy both in SCSI and NVMe where error handling
> is left entirely to the userspace program issuing the I/O.
> 
> So this does radically change behavior in a very unexpected way.
> Why?

I think the difference from scsi-generic and controller nvme passthru is
that this is a mpath device node (or mpath chardev). This is why I think
that users would expect that it would have equivalent multipath
capabilities (i.e. failover).

In general, I think that uring passthru as an alternative I/O interface
and as such needs to be able to failover. If this is not expected from
the interface, then why are we exposing a chardev for the mpath device
node? why not only the bottom namespaces?

I can't really imagine a user that would use uring passthru and
when it gets an error completion, would then try to reconcile if there
is an available path (from sysfs?), and submitting it again in hope that
an available path is selected by the driver (without really being able
to control any of this)...

Maybe I'm wrong, but it looks like an awkward interface to operate on a
multipath device node, but implement failover yourself, based on some
information that is not necessarily in-sync with the driver.

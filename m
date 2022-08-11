Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A20D590083
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 17:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiHKPn7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 11:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbiHKPnp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 11:43:45 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AF59FAB6
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 08:38:16 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id c5so423261ilh.3
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 08:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc;
        bh=KO3raM6ybRo6Io+WhT3diaErE++wqwgEByg9nvNi494=;
        b=VDjMjxNenmn0wVs3zX2PSXMI23rlKrU8bmkefya/wFWCAP0hAlBo+iUD3v9/XOR6ZW
         RCqWfQXCVwR6f6AE+81Okixm0/6SJ27HKamoFQrEprSuxtNCdQUJaE/LTokNPPfvvcZv
         +P3gC7DdJ6WhcfSX2/I51CQ+TevczA/yHnLqS9N+vcu8lSYL47+sEwAYU4Frx5HeA5nf
         1uqLUObREnde3vNoYh8/vA0Yc4K3i1Ft3uVWSoEbmVyjb8cnc5etc4Ng891CiUBXWuKr
         S6siUL6/mXBWCHYHfmTtioADfkBmjdHi0adMB9l9cOm4/ZioEE3DoR1N8KmkkVX8/Dqj
         o8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc;
        bh=KO3raM6ybRo6Io+WhT3diaErE++wqwgEByg9nvNi494=;
        b=p34HaMERCROT169PJUEjOpDNO3mUCgEuehVKQVbxn4HGXzWyshy5Y2pwyaB6XSfHYh
         oysamkDQeaeY5JcGgT2P4Mk6s8pDwdTZvDotXyudY6Q4rrIaRlJKJ2LiL022msg2EfKP
         7a/+mstCBNXyk+CQE5idgz1LV6J8uJu57YGRaa0ZFcd+aXMkyoHaoRrheJMtBNnNJy2j
         y7hfuD5BsKB6QauJW+GccjJ6hYxj/xVytwHE4J1khUfbP7w9rHCzTcAN4u+rpxXUdeIn
         khUgGZAbcODaOAWLQZnEraYWIRdOlukLJ9xBpWB5DnZwLj6+x8sIqcwRki29KnVPvxIj
         igSg==
X-Gm-Message-State: ACgBeo27xpykD1nfhNq5DgHHsj5YOt2PP1zUJ+P03sZOR0obHUrYNaH+
        B96pRvdT1YcsS4h296+ZmzI7EzOSlsEMVw==
X-Google-Smtp-Source: AA6agR6kt0spXL+8Pf+8KRRhOLh6uJt6CQdZUFpzb4j+rhBhslhWdzqFnAAhqstg7IB5pNSYPT4hog==
X-Received: by 2002:a05:6e02:1b8f:b0:2df:2930:28e4 with SMTP id h15-20020a056e021b8f00b002df293028e4mr15445120ili.198.1660232295434;
        Thu, 11 Aug 2022 08:38:15 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r2-20020a02b102000000b003433d46b408sm2148559jah.85.2022.08.11.08.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 08:38:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, metze@samba.org
In-Reply-To: <cover.1660201408.git.metze@samba.org>
References: <cover.1660201408.git.metze@samba.org>
Subject: Re: [PATCH 0/3] typesafety improvements on io_uring-6.0
Message-Id: <166023229481.192529.11362562365058444938.b4-ty@kernel.dk>
Date:   Thu, 11 Aug 2022 09:38:14 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 11 Aug 2022 09:11:13 +0200, Stefan Metzmacher wrote:
> with the split into individual files (which is gread)
> and the introduction of the generic struct io_cmd_data,
> we now have the risk do incompatible casting in
> io_kiocb_to_cmd().
> 
> My patches catch casting problems with BUILD_BUG_ON() now.
> While there I added missing BUILD_BUG_ON() checks
> for new io_uring_sqe fields.
> 
> [...]

Applied, thanks!

[1/3] io_uring: consistently make use of io_notif_to_data()
      commit: 3608c38ea378cb7bb2d43ebe43c468c7be58b83a
[2/3] io_uring: make io_kiocb_to_cmd() typesafe
      commit: 28789defa868b7b731ed73cfd7e0c0bfcd901de7
[3/3] io_uring: add missing BUILD_BUG_ON() checks for new io_uring_sqe fields
      commit: 4167efe6463b09505112b6dc2c30b8ac68fcf348

Best regards,
-- 
Jens Axboe



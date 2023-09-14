Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728207A0A48
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 18:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241469AbjINQGB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 12:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241553AbjINQGA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 12:06:00 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECEE1BEF
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 09:05:56 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7950d0c85bbso2391939f.1
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 09:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694707555; x=1695312355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OVESXVsiOT9W2PQQ2MWB3fGAx8KoRg0hhH0OfAX37Mk=;
        b=jrCRf6Zvx70WUBJnRV2CH8pf2Raj8TdLY6/OuafZvGOKmoy4noSaBBl2/zbDBr6sjX
         teur1ap0z7Y3mK5tN5dDgMeInt9/Scbr5YGVnczbqxb7++vYqQ8BwTFNJPvsATBqkyyb
         sXOCNdsw/z5eDK41lcNKwl8hNCfQQ4Yue83XKr8iEBJ1nQbR65YJziKcUopXtpmYBrev
         w+DvL7RF0F9HfTX3N3GLJFjQ+wTIVQvGT0tkBQ05/c7kd6UspJ6Ql2INEemnsuvFOWre
         FTNdgm/ELMDfDdeSl+JsZn/j4rqLA5yuzBoQmUws6WfarKxrXTf7QLYAqGidymKNBq2D
         h+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694707555; x=1695312355;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OVESXVsiOT9W2PQQ2MWB3fGAx8KoRg0hhH0OfAX37Mk=;
        b=dZqmH8MEVSCNoU0+reCN2FS9VBpVficitrpYuplN/MXBgtRP0UQDcgi3Io/PUb3SyZ
         SSJuligoC6szTOU4z6AiF4JftUaIDJcVUEn+i6jJZcyvQf5EmcZUrsif8LlSx+Mp40YJ
         dpuvWx2OLEMonHsOtWkeoz5HvilbhNhSKIJOnuKuX84Y9KCYXeHd1EvtbBQPqUJV+CR0
         Wjrp3ZVxzc/xeAU8YbUxfPcDipGnWOcrULJYSIerAChVxqNSWA2m61J8xpv4k7dYGtGD
         +28m+8RYN/u4njv+jgZKcU3HacaKSfQIMAUEAKFgupKgMlSvEehXQsmjxUI4RtWpOz0T
         BX7A==
X-Gm-Message-State: AOJu0Yw5bRUqV+XjnuZZJy2aZ1Ovss7QASFwL5pzrQhbWcEpBJY+Azh5
        kbUV0YIhOT4OzxPP6Wb+vBk5VOsznGwDnySKTxUa/A==
X-Google-Smtp-Source: AGHT+IF8EAkjdGP9Q1z2hyLcIe1LVTfesLXALQGrjwrKQMnVk9Pbh1gA3TZxdjGk+v0/vi8EGQ0dyQ==
X-Received: by 2002:a92:c9c6:0:b0:34c:d535:9f9d with SMTP id k6-20020a92c9c6000000b0034cd5359f9dmr5660992ilq.1.1694707555281;
        Thu, 14 Sep 2023 09:05:55 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e7-20020a926907000000b0034cd2c0afe8sm523083ilc.56.2023.09.14.09.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 09:05:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com
In-Reply-To: <e092d4f68a35b7872b260afc55c47c7765a81ef9.1694706603.git.asml.silence@gmail.com>
References: <e092d4f68a35b7872b260afc55c47c7765a81ef9.1694706603.git.asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/net: fix iter retargeting for selected buf
Message-Id: <169470755399.1974464.15114864898622809643.b4-ty@kernel.dk>
Date:   Thu, 14 Sep 2023 10:05:53 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 14 Sep 2023 16:51:09 +0100, Pavel Begunkov wrote:
> When using selected buffer feature, io_uring delays data iter setup
> until later. If io_setup_async_msg() is called before that it might see
> not correctly setup iterator. Pre-init nr_segs and judge from its state
> whether we repointing.
> 
> 

Applied, thanks!

[1/1] io_uring/net: fix iter retargeting for selected buf
      commit: 78a6953889b1912106bfb6e59ead30a79da90e29

Best regards,
-- 
Jens Axboe




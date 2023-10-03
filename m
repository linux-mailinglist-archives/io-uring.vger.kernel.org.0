Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96467B5EEA
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 04:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238955AbjJCCFl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 22:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238959AbjJCCFk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 22:05:40 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E94BB
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 19:05:37 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-273e3d8b57aso93666a91.0
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 19:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696298737; x=1696903537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uRcjc2hBSOekgkWKiY4CMq6tRdwKpz67PdIgVrIx4Q4=;
        b=GGX/grzuOwoxtoKNSFAFSv1h1AyJMddm2qa5rDgSG0hyBSYzxNgkrJqT8xL907vrbW
         tZXxjQMtu/82mZa7JwL9DqGmrEky8252Rno6224dOf5mt0qsR3SQvYdWo6mebLGry/dC
         MEEDGQ/9TnHt6BgIOi+KJS2KShrpZiFt/pDMHybMBwrY+eTpfJyri5+ygrQcj/RZCLAV
         j6QxNDUAXOW7zgOFu06g8p6OlZjqwrVKRElVlmBo0pWZ7bhbUF3PB1ZWGcfbijdGmA3n
         9TUE/PESddi/cwGNaIDHr/kOx0wXAmPm4dOJ7m6B8vXJFUji1v43dbJCu26eCe5edmKJ
         Mdog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696298737; x=1696903537;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uRcjc2hBSOekgkWKiY4CMq6tRdwKpz67PdIgVrIx4Q4=;
        b=OQbc3Q8tv9hr5QUmQaIxJbs+ZQyUxaQMt/BY+u0MgqcfXiUbROx0fewKLXBf0v17co
         3+ecBvY+nc993MF7g2JFgNWOfi6Cvl5sC63B3lp4ruemv6HuPo2DtYZnHhrV/MoYVqcK
         MflL6RmNoFXNMloOiLbuzzKT/twIhEWUOB5wd9rep8AM8BZqRqYU1oCFf2i+tqJaOuwd
         TflmkQ4VYv0bo8Q5llLVMW98CSy3qytZ0X0YvkpEFGQenPnXKXKuG8KciUuzHtyaeiU+
         x811GzDVvPFTXObei595n/v7jZRkWhF8u6mGgADDtwSplZAmaOlQMACJpPggKLAnxJ2T
         iHxg==
X-Gm-Message-State: AOJu0Yxezl2dItB7NE31JEG4vX/0EN6w5N28yB65+PhzvQoV8xLiaErd
        Je/7WjZb3aMTV6crGKqz6Y8rOg==
X-Google-Smtp-Source: AGHT+IFFeF2RSw73sMGZA2WckEmTqV1VHRudpN9DZ8owBcqThI47QPnkBvfL1UY8TLFPtVytoXwG2w==
X-Received: by 2002:a05:6a00:4691:b0:693:38c5:4d6d with SMTP id de17-20020a056a00469100b0069338c54d6dmr12489933pfb.2.1696298737213;
        Mon, 02 Oct 2023 19:05:37 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id q28-20020a638c5c000000b005742092c211sm160428pgn.64.2023.10.02.19.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 19:05:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <20230928124327.135679-1-ming.lei@redhat.com>
References: <20230928124327.135679-1-ming.lei@redhat.com>
Subject: Re: [PATCH V5 0/2] io_uring: cancelable uring_cmd
Message-Id: <169629873580.1745606.14847062358187411158.b4-ty@kernel.dk>
Date:   Mon, 02 Oct 2023 20:05:35 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 28 Sep 2023 20:43:23 +0800, Ming Lei wrote:
> Patch 1 retains top 8bits of  uring_cmd flags for kernel internal use.
> 
> Patch 2 implements cancelable uring_cmd.
> 
> git tree(with ublk change)
> 
> 	https://github.com/ming1/linux/commits/uring_exit_and_ublk
> 
> [...]

Applied, thanks!

[1/2] io_uring: retain top 8bits of uring_cmd flags for kernel internal use
      commit: 528ce6781726e022bc5dc84034360e6e8f1b89bd
[2/2] io_uring: cancelable uring_cmd
      commit: 93b8cc60c37b9d17732b7a297e5dca29b50a990d

Best regards,
-- 
Jens Axboe




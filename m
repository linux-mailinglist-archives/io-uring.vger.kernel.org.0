Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B75E5E8482
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 23:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiIWVCz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 17:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiIWVC3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 17:02:29 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575C5115BE5
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 14:01:38 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id m16so767271ili.9
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 14:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=WWQdz9gCAeTkBuCrtktLQzCwnD4zzk63LjP1v/eIuKU=;
        b=Zl9f3TumBnsHg7bQhOvhvFtqyGe+MCVOZRedR3wFwOdD3e4q1RCGNbD/mjzDQOGumS
         Bz0D/ozx0dcDKnc0QcoVLsCYGwlqvyQrucAislNZjneo6aiavqQiHi6OyXbUDnRIt2p3
         Ndg9YjYqkfgqx76fi4p1eLdsc3JMqNDIAdezRYYnA5AxAXFyVJNyIIRkoeRFAwo4H3Dn
         h1BeCDRKZ4Q9IH7LaG+GzyziKYGWaeHu4Xk0S7cDem+fiwwzN+mW2z1F/6I8HFkmwwFG
         jay1AcDgUHqHKFWv/YItFOC+RPnmQpbf2e1vmyIJpQ9HZ70APC89yG7G9DJTICW/bZ7j
         IlIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=WWQdz9gCAeTkBuCrtktLQzCwnD4zzk63LjP1v/eIuKU=;
        b=Cw7dB4PWtRFzF//RmYSXL3BajZtU0y5EwZXX4wdUq72jg1v3WZDUMDbi+9TYFmfVJK
         6pfXjtJf2ruztDoKPU/ieP3dn6ETTRqpQgGFMqr4usZxpVdwrV9k35JxMCa4NGsCWTYY
         yWcYdJcUCXjS1hgGn8r0GMrGg8SupyOFXET0rjTwxQJ9x2V2ReQpG72KeUa00GYCn5lu
         BZvl75nw3lzuDulAduCawYpX55WayZC9orWAANW55TIHxZn8xjBg+rD5mhTgZ0dJj63l
         Z+VN6EKafXxNU1d8wDhpsPcNXOKN+IRh16JtwniKWNh/vuK3zFI2iV2K8rboMA1EI1ah
         vsng==
X-Gm-Message-State: ACrzQf0dFJaKi1zzniqI+HYXs2LM2RUewDTpuf8DVLxzBCutDsgUpp0n
        olY1+tsF/ZuF3HolN4W8ivpLkc36vHWsog==
X-Google-Smtp-Source: AMsMyM5JQTQg800w2pG12JTLuq0aewvsEonTPxdpWo6Tm+NUfnLDqSqZnk6Hd5T7fwORHMQbjI5lVw==
X-Received: by 2002:a05:6e02:1688:b0:2f2:179b:a648 with SMTP id f8-20020a056e02168800b002f2179ba648mr4882851ila.201.1663966897202;
        Fri, 23 Sep 2022 14:01:37 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b5-20020a92c845000000b002f626355114sm3556130ilq.4.2022.09.23.14.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 14:01:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aac948ea753a8bfe1fa3b82fe45debcb54586369.1663953085.git.asml.silence@gmail.com>
References: <aac948ea753a8bfe1fa3b82fe45debcb54586369.1663953085.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 1/1] selftest/net: adjust io_uring sendzc notif handling
Message-Id: <166396689658.501295.6862107981627555585.b4-ty@kernel.dk>
Date:   Fri, 23 Sep 2022 15:01:36 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-355bd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 23 Sep 2022 18:12:09 +0100, Pavel Begunkov wrote:
> It's not currently possible but in the future we may get
> IORING_CQE_F_MORE and so a notification even for a failed request, i.e.
> when cqe->res <= 0. That's precisely what the documentation says, so
> adjust the test and do IORING_CQE_F_MORE checks regardless of the main
> completion cqe->res.
> 
> 
> [...]

Applied, thanks!

[1/1] selftest/net: adjust io_uring sendzc notif handling
      commit: 4781185da411c0b51ef9b1db557c1ea28ac11de4

Best regards,
-- 
Jens Axboe



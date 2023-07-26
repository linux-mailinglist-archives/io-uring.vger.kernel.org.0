Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECA5763CC0
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 18:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjGZQo0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 12:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjGZQoZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 12:44:25 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C4F2716
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 09:44:18 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-346434c7793so6807625ab.0
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 09:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690389857; x=1690994657;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MvAgiSRmmqjQuNSTvLvzhCp2dGR6DqVK9AaLsBcxns=;
        b=ns+rOP5oX61phHnuBj++0wNoZJ7yKblh7Wh8NOL+Rb+Hm9ygQ2X5LFW319K/8SjQ0/
         wa+7wnnDVEwblxlo/uZYR0ddHibvcRB7mhqKN4ohDjiKlh4B7yS5BjEE5Cn0KBXGAGfO
         IqYz5UIGcioEORU69Hw9anTYRiZyXps0Hz32gOprLY2L1uKrkEevL5RZDhF16lwQw5Qe
         FPMQlxtH1yL0xJbyZ0+AeZ6IpR42n8w7P6BTcXt5rCNJTPPAqRuPDEjfWk+6UOAqKLHY
         R39IsO5dxwaDheXaBsbsISB2vlgCiOX+pLJTZ318pwraW/RYPu3mnUaBGm6mJhv6DuCA
         fbmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690389857; x=1690994657;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2MvAgiSRmmqjQuNSTvLvzhCp2dGR6DqVK9AaLsBcxns=;
        b=ADHv7leQsitrkp9yX/QgQ8vkvKP1vDifuZ8ov68CUWjc1TlB5+jgW+t0D1QciG2ij9
         FR4TeMEHnUBPMmrHQOlUjLXNCUWzuOWEbdxhcRbo6HqFBCMyfapxFqek/b5SIOQyTIiX
         CexWJIVVFK48DcSWDiZKJRS+V5/PXcRT60XLPq3NLhqOn+Hx+pw7LoGsljBcLa0ivOPI
         dYLpv/fznNeqEiti3QPQMjjyHJ7MfEdikrbmzTBA/tdbsybiysKDqSSS9YE6WNEDLeM5
         SfNmLW/gQV9/e7QO4Ob6CWEyBK242aczu3leux0UQiaRF6TIPxfQ2nghRi35HdJQ6fj0
         Yo5Q==
X-Gm-Message-State: ABy/qLaUbmRWj98lXgHZVtSa1z1tF9bcr4KkJTVT6pT5G9fxmZvB4IkG
        TA0uRma4QNrLYMovYJ6t/8c0Lw==
X-Google-Smtp-Source: APBJJlEB91rbYnaP2LHDb57KP3z2y30FE7fZyyItopmcLqEzRiw5IPgPfIAPfJ8Y6oZpET8xjhHYSQ==
X-Received: by 2002:a6b:1446:0:b0:77a:ee79:652 with SMTP id 67-20020a6b1446000000b0077aee790652mr2185498iou.1.1690389857420;
        Wed, 26 Jul 2023 09:44:17 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n4-20020a6bed04000000b00786fe5039b8sm4792120iog.46.2023.07.26.09.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 09:44:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Breno Leitao <leitao@debian.org>
Cc:     gregkh@linuxfoundation.org, kuniyu@amazon.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20230627134424.2784797-1-leitao@debian.org>
References: <20230627134424.2784797-1-leitao@debian.org>
Subject: Re: [PATCH v4] io_uring: Add io_uring command support for sockets
Message-Id: <169038985660.932464.4047750126367212263.b4-ty@kernel.dk>
Date:   Wed, 26 Jul 2023 10:44:16 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 27 Jun 2023 06:44:24 -0700, Breno Leitao wrote:
> Enable io_uring commands on network sockets. Create two new
> SOCKET_URING_OP commands that will operate on sockets.
> 
> In order to call ioctl on sockets, use the file_operations->io_uring_cmd
> callbacks, and map it to a uring socket function, which handles the
> SOCKET_URING_OP accordingly, and calls socket ioctls.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Add io_uring command support for sockets
      commit: 95ba83afd0968d4699054e613033d1cefb295845

Best regards,
-- 
Jens Axboe




Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19341740312
	for <lists+io-uring@lfdr.de>; Tue, 27 Jun 2023 20:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjF0SSG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jun 2023 14:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjF0SSF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jun 2023 14:18:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507CCE71;
        Tue, 27 Jun 2023 11:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9681611FB;
        Tue, 27 Jun 2023 18:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF41AC433C0;
        Tue, 27 Jun 2023 18:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687889881;
        bh=iYtIyO/ySZzF+IOqcCHeQhRSytBBD9onL/5yGdI7F1Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ngOGXNaHdjsvIlZnF6+wsprKCBG6oiYmUo7UWH9qOldOrru82Gsd5DOlMImLDyOl2
         Hha2ReO5/ORJUUDk9UD2sT5dJskIzJ6kpPi/GCaHL7z7ZouqkTj5YbeOMZuOR9Hjfi
         3a+bQtdw0pjAhC9Xq1xEWY2jclbs0yYJzIPaNGU06hRGbxcBD7wSimGe1/CQohQYkr
         193QgmOkDMnG88T68YtlFm0OgD6Nr4FFdorTwDLSwQjOPKNkVUPDLW3fcyjsfopSZ0
         LxeY+RgDwODdIQlfD1AnJXwiuNcJHmoVAheTZmykwGuDQ9qbGVYk2DWJ+gLp2yp+0e
         BOCzttu8uS/oA==
Date:   Tue, 27 Jun 2023 11:18:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Breno Leitao <leitao@debian.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, gregkh@linuxfoundation.org,
        kuniyu@amazon.com, io-uring@vger.kernel.org (open list:IO_URING),
        linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: Re: [PATCH v4] io_uring: Add io_uring command support for sockets
Message-ID: <20230627111800.70035051@kernel.org>
In-Reply-To: <20230627134424.2784797-1-leitao@debian.org>
References: <20230627134424.2784797-1-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 27 Jun 2023 06:44:24 -0700 Breno Leitao wrote:
> Enable io_uring commands on network sockets. Create two new
> SOCKET_URING_OP commands that will operate on sockets.
> 
> In order to call ioctl on sockets, use the file_operations->io_uring_cmd
> callbacks, and map it to a uring socket function, which handles the
> SOCKET_URING_OP accordingly, and calls socket ioctls.
> 
> This patches was tested by creating a new test case in liburing.
> Link: https://github.com/leitao/liburing/tree/io_uring_cmd

It's a bit late for net-next to take this, I'm about to send our 6.5 PR.
But in case Jens wants to take it via io_uring for 6.5:

Acked-by: Jakub Kicinski <kuba@kernel.org>
-- 
For netdev:
pw-bot: defer

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065846B5D11
	for <lists+io-uring@lfdr.de>; Sat, 11 Mar 2023 15:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjCKO6n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Mar 2023 09:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCKO6n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Mar 2023 09:58:43 -0500
X-Greylist: delayed 1799 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 11 Mar 2023 06:58:35 PST
Received: from lounge.grep.be (lounge.grep.be [IPv6:2a01:4f8:200:91e8::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA57A28EAF;
        Sat, 11 Mar 2023 06:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=uter.be;
        s=2021.lounge; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IdBdhMyytPprLhvmwH0QAEbMk/enH69jbhBiFJLO9mk=; b=XTiCvEZdkANORiKCfWUpe73rsn
        gw7fYcWdv8IxzjFo+s37bK3h7TOvhlg42S+W6B73XyRzi6pj4mEC+Y3tjxlp7hRUXDP8UuZeGTir/
        Pm9EWNd0iOMJPoMqucVY8S1gUsZdmJx7HCyWnbmQ7V2jAbtLyFujhJjIKcA7TcKf3AzO/V7304DSS
        /ytaQ3DISxrSh2qu+LLmgumwHcPwqfGdPDIaJYdpbQtRzLHJJDqXu3Yl54T1MD4bq3Wk+U7WvDYN4
        hIstpsdkkDzCAeHR9ahahfc6FXFAEMRe44sxs47LT2n9NzIAVzxA3IcxUkfO+9SV9qEVWSSojBa+J
        CTBJG3Iw==;
Received: from [102.39.141.34] (helo=pc220518)
        by lounge.grep.be with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <w@uter.be>)
        id 1pazAk-005byT-D3; Sat, 11 Mar 2023 14:22:06 +0100
Received: from wouter by pc220518 with local (Exim 4.96)
        (envelope-from <w@uter.be>)
        id 1pazAd-0014wX-0u;
        Sat, 11 Mar 2023 15:21:59 +0200
Date:   Sat, 11 Mar 2023 15:21:59 +0200
From:   Wouter Verhelst <w@uter.be>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@other.debian.org
Subject: Re: ublk-nbd: ublk-nbd is avaialbe
Message-ID: <ZAyAdwWdw0I034IZ@pc220518.home.grep.be>
References: <Y8lSYBU9q5fjs7jS@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8lSYBU9q5fjs7jS@T590>
X-Speed: Gates' Law: Every 18 months, the speed of software halves.
Organization: none
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On Thu, Jan 19, 2023 at 10:23:28PM +0800, Ming Lei wrote:
> The handshake implementation is borrowed from nbd project[2], so
> basically ublk-nbd just adds new code for implementing transmission
> phase, and it can be thought as moving linux block nbd driver into
> userspace.
[...]
> Any comments are welcome!

I see you copied nbd-client.c and modified it, but removed all the
author information from it (including mine).

Please don't do that. nbd-client is not public domain, it is GPLv2,
which means you need to keep copyright statements around somewhere. You
can move them into an AUTHORS file or some such if you prefer, but you
can't just remove them blindly.

Thanks.

-- 
     w@uter.{be,co.za}
wouter@{grep.be,fosdem.org,debian.org}

I will have a Tin-Actinium-Potassium mixture, thanks.

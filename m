Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA1F59D180
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 08:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240264AbiHWGwU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 02:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiHWGwS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 02:52:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135B232EF3;
        Mon, 22 Aug 2022 23:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCAA6B8105C;
        Tue, 23 Aug 2022 06:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F68C433C1;
        Tue, 23 Aug 2022 06:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661237535;
        bh=H0QVObamMUvkLlbXRgZccEpBQCS/mDXJT7w45m0x02Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y9DpvNQsgiMSeRm18qZsNgcRFiA3Enw0nsG238i7ATeTTfJeAdqp8p26lqVSYriLT
         Zk0IcW0XA/qKk8q63z0tEgQZfJHJjr+Jn0GxJsn45p824OWp9de4KccEyOwm5PJQui
         sN8WneURuVbfV9Zi9ReXm/zB5QBtQVcQjBCk3WTA=
Date:   Tue, 23 Aug 2022 08:52:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 3/3] /dev/null: add IORING_OP_URING_CMD support
Message-ID: <YwR5HBazPxWjcYci@kroah.com>
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327984.369593.8371751426301540450.stgit@olly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166120327984.369593.8371751426301540450.stgit@olly>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 22, 2022 at 05:21:19PM -0400, Paul Moore wrote:
> This patch adds support for the io_uring command pass through, aka
> IORING_OP_URING_CMD, to the /dev/null driver.  As with all of the
> /dev/null functionality, the implementation is just a simple sink
> where commands go to die, but it should be useful for developers who
> need a simple IORING_OP_URING_CMD test device that doesn't require
> any special hardware.

Also, shouldn't you document this somewhere?

At least in the code itself saying "this is here so that /dev/null works
as a io_uring sink" or something like that?  Otherwise it just looks
like it does nothing at all.

thanks,

greg k-h

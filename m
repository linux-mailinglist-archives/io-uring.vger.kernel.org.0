Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8C24C57E4
	for <lists+io-uring@lfdr.de>; Sat, 26 Feb 2022 21:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiBZUBz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Feb 2022 15:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiBZUBz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Feb 2022 15:01:55 -0500
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831B01FEDA9;
        Sat, 26 Feb 2022 12:01:20 -0800 (PST)
Received: by mail-pg1-f175.google.com with SMTP id e6so6510208pgn.2;
        Sat, 26 Feb 2022 12:01:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ASY7hqm9B5n/GIX+j2xNOyev7bD6a1d/S/a6NvKTtHI=;
        b=fbP7wI5iTydfA7l1/ZyDPz1YS47pcCUs+Paeu2eACpCZq5VN9R+rwAKf8493OYqLH+
         sjoAJImyxmhT+Er5NaYQUBoGbDtyRw8NJkSz7RzhimntCzAJJ7dDaF4rnQ9/4s57c4MW
         nS0/OKdk11cR2xoggYCy9nAZfUYhqVTt4eAmhDADstqYocrnUgjevX3ObG8muUrTCZcK
         PhvKcEJ3TbPppwrZJ+iZ4MRKpxhQ92rxOu0EBVWDMeDvGkyjwuxs5PlSx52IxJ0T/7sO
         Ln9dqCxyHjdYCkWml9urLHE2n5EoDsLIseeppsJ3I+uMXIyOdqseU3zsER3g5mIHFeJF
         cC9A==
X-Gm-Message-State: AOAM531MsPyvt0cnTJbJctOjSUrILrtm5hbZxDPc0bAz7jNaWt8ZUJgX
        pyP66cbwmuZNSxAtv6JrXMU=
X-Google-Smtp-Source: ABdhPJzgSI6+JZg+wKkfXVw+XFmcfQ8SfMsQlxPfETGtTsrP5EiTXucsWPCI0ZCc+vG8v3RfUOo//Q==
X-Received: by 2002:aa7:9f5b:0:b0:4cc:964c:99dd with SMTP id h27-20020aa79f5b000000b004cc964c99ddmr13919819pfr.42.1645905679789;
        Sat, 26 Feb 2022 12:01:19 -0800 (PST)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
        by smtp.gmail.com with ESMTPSA id y16-20020a056a00191000b004e155b2623bsm8066314pfi.178.2022.02.26.12.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 12:01:18 -0800 (PST)
Date:   Sat, 26 Feb 2022 12:01:16 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, viro@zeniv.linux.org.uk, rostedt@goodmis.org,
        m.szyprowski@samsung.com
Subject: Re: [PATCH v4 1/1] io-uring: Make statx API stable
Message-ID: <20220226200116.mlirionrzr3ujvx4@garbanzo>
References: <20220225185326.1373304-1-shr@fb.com>
 <20220225185326.1373304-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225185326.1373304-2-shr@fb.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 25, 2022 at 10:53:26AM -0800, Stefan Roesch wrote:
> One of the key architectual tenets is to keep the parameters for
> io-uring stable. After the call has been submitted, its value can
> be changed. Unfortunaltely this is not the case for the current statx
> implementation.
> 
> IO-Uring change:
> This changes replaces the const char * filename pointer in the io_statx
> structure with a struct filename *. In addition it also creates the
> filename object during the prepare phase.
> 
> With this change, the opcode also needs to invoke cleanup, so the
> filename object gets freed after processing the request.
> 
> fs change:
> This replaces the const char* __user filename parameter in the two
> functions do_statx and vfs_statx with a struct filename *. In addition
> to be able to correctly construct a filename object a new helper
> function getname_statx_lookup_flags is introduced. The function makes
> sure that do_statx and vfs_statx is invoked with the correct lookup flags.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

At least it doesn't break my KVM boots anymore:

Tested-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0594E60A6
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 09:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349021AbiCXIwg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 04:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344839AbiCXIwg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 04:52:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2EF694BF;
        Thu, 24 Mar 2022 01:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8724B822B8;
        Thu, 24 Mar 2022 08:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD997C340F2;
        Thu, 24 Mar 2022 08:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648111861;
        bh=zyEBP3NXJSPM4vqg79kg/aI5apPLEpA3Y3UHaH+XDOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e8ZUZQaT6KEHwk37YBjzbswlh+JIG/eLkNAxhC+tCHuRRiTp6ZJtse/NM/ZhY5vLl
         zmHSy4xc7wIcBbsEBVsJvmV4hmD3TSmZKMjXJ2c56CFITB+7DQ7WS2nesXj7VU0Z9I
         pAs/p+oUk1NRGjIuRJ/IdQVVIWkk1PqJLHxpHd5xIdnpsF2ex9niYMnW7OyS5f/PZS
         J7kE9Gc0URimSOVYFvBJcn/ZddIIyRnPLcH3yiijfKPiN0qXfjPZhHAYVSxPdXvRCv
         KQrSCxQkR2KeMfAhI7ESDDBco+mBLfhiJ1IWF/FIzW3eIegLukKRswYPgscJsD5r+5
         yMhg6mv6ChLVg==
Date:   Thu, 24 Mar 2022 09:50:56 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, viro@zeniv.linux.org.uk,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v13 4/4] io_uring: add fgetxattr and getxattr support
Message-ID: <20220324085056.zr2cfa2esy7zt44t@wittgenstein>
References: <20220323154420.3301504-1-shr@fb.com>
 <20220323154420.3301504-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220323154420.3301504-5-shr@fb.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 23, 2022 at 08:44:20AM -0700, Stefan Roesch wrote:
> This adds support to io_uring for the fgetxattr and getxattr API.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>

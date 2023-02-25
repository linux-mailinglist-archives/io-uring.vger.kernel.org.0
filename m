Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77316A2BC9
	for <lists+io-uring@lfdr.de>; Sat, 25 Feb 2023 22:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBYVCp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Feb 2023 16:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBYVCp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Feb 2023 16:02:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336AE14E90;
        Sat, 25 Feb 2023 13:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C253B80B32;
        Sat, 25 Feb 2023 21:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E37C433D2;
        Sat, 25 Feb 2023 21:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677358961;
        bh=dAdczosGMLE3reQ+yfqGchmgVwzqD0s258AHR5QDBk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=alNPgnU7am/djLnV5nPooemcTFnojh9BxoSgHaOyQ1zVw/FmC9FHnkLEdsZbYmyo1
         myAxBpFmRRNHwYDF/RDFqVU53010sqZCOx0YG4deO0d5f7R/9zChC/0WdjTHh8h6rS
         9ad9+j7MEIPfQW8G40OfvZyJ7mjkjFPib3GnbAUc=
Date:   Sat, 25 Feb 2023 13:02:39 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     kernel test robot <lkp@intel.com>
Cc:     linux-usb@vger.kernel.org, linux-mm@kvack.org,
        linux-bluetooth@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        io-uring@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [linux-next:master] BUILD REGRESSION
 8232539f864ca60474e38eb42d451f5c26415856
Message-Id: <20230225130239.d25f657955d3c4462c80d128@linux-foundation.org>
In-Reply-To: <63fa411f.ZvVOisJt5OlLzGYF%lkp@intel.com>
References: <63fa411f.ZvVOisJt5OlLzGYF%lkp@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 26 Feb 2023 01:10:55 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 8232539f864ca60474e38eb42d451f5c26415856  Add linux-next specific files for 20230225
> 
> Error/Warning reports:
> 
> mm/page_alloc.c:257:1: sparse: sparse: symbol 'check_pages_enabled' was not declared. Should it be static?

It should!

--- a/mm/page_alloc.c~mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix
+++ b/mm/page_alloc.c
@@ -254,7 +254,7 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 EXPORT_SYMBOL(init_on_free);
 
 /* perform sanity checks on struct pages being allocated or freed */
-DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
+static DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
 static bool _init_on_alloc_enabled_early __read_mostly
 				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
_


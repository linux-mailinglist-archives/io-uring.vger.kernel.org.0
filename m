Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE1B7400D5
	for <lists+io-uring@lfdr.de>; Tue, 27 Jun 2023 18:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjF0QYD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jun 2023 12:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjF0QX6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jun 2023 12:23:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EF430EC;
        Tue, 27 Jun 2023 09:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=/4TlpfcV9w6VY9Wp7NMoSSjTCcDuCDvKDEUtb/e8aoY=; b=TSd0mxAFGlDcWEi9yXYnWluOUs
        NldrvE0DKu1dHstL1JbzHINhrsfGcxz5LnCr5JS37ath2Ad9iVy/m5muvX4guNZ16jtoNWrtqGOvm
        eZNQ0U5lHgWJEqRiExXBRaN4r4JqxAgc4fz4GxJRRzhYMANh4SKueIOWGtsUCxKZ9LZZvGMIH7UaU
        rJrK4a/x13v4sAa1AzeEEaVg/JpWQiw2vMqt1bfX8/oVxivdyPzX8FJqYXFvybb301UzLa5hZ+dvi
        Wx85YNW9fxLnRzdLddyCmbgWFNF237gROBrD6jAGbmmz0Yu7TyVXiD+HESVQMEO8JVpoTZ1i33uTj
        U6IqmO6g==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qEBTt-00DdCA-01;
        Tue, 27 Jun 2023 16:23:53 +0000
Message-ID: <0d8f8e2b-166b-14bc-6879-a2521ea5b23d@infradead.org>
Date:   Tue, 27 Jun 2023 09:23:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 1/1] Add a new sysctl to disable io_uring system-wide
Content-Language: en-US
To:     Matteo Rizzo <matteorizzo@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     jordyzomer@google.com, evn@google.com, poprdi@google.com,
        corbet@lwn.net, axboe@kernel.dk, asml.silence@gmail.com,
        akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, dave.hansen@linux.intel.com,
        ribalda@chromium.org, chenhuacai@kernel.org, steve@sk2.org,
        gpiccoli@igalia.com, ldufour@linux.ibm.com
References: <20230627120058.2214509-1-matteorizzo@google.com>
 <20230627120058.2214509-2-matteorizzo@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230627120058.2214509-2-matteorizzo@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi--

On 6/27/23 05:00, Matteo Rizzo wrote:
> diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
> index d85d90f5d000..3c53a238332a 100644
> --- a/Documentation/admin-guide/sysctl/kernel.rst
> +++ b/Documentation/admin-guide/sysctl/kernel.rst
> @@ -450,6 +450,20 @@ this allows system administrators to override the
>  ``IA64_THREAD_UAC_NOPRINT`` ``prctl`` and avoid logs being flooded.
>  
>  
> +io_uring_disabled
> +=========================
> +
> +Prevents all processes from creating new io_uring instances. Enabling this
> +shrinks the kernel's attack surface.
> +
> += =============================================================
> +0 All processes can create io_uring instances as normal. This is the default
> +  setting.
> +1 io_uring is disabled. io_uring_setup always fails with -EPERM. Existing
> +  io_uring instances can still be used.
> += =============================================================

These table lines should be extended at least as far as the text that they
enclose. I.e., the top and bottom lines should be like:

> += ==========================================================================

thanks.
-- 
~Randy

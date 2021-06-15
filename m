Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAC23A8B47
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 23:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhFOVmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 17:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbhFOVml (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 17:42:41 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A95DC061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:40:37 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id s23so116044oiw.9
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QvHRlN/FiOE37BimGmhAJvTh/MyrPZOwXFm2koNz7uA=;
        b=oUMw+lguOn50tgR8W3+aSqZclURiYBLoencJj1extvASCkKgrn5iz/u4MKw+9cCBli
         xMf0+HEykZF8ci+cmW5ZfHLrF518q93DtxfmIS8gdtEYdSkgqTRg+EiULCt78CQb18Ie
         CjBx/IYQ+74uUAEUcpVBAoWFPRczcxSuN+q8kP49uz4O/eizVXaHctfFhjHQ29YPkPJY
         eZgJdiWY4N5yrkJEw9cS7CCCoJ2lSTXhXi/xCs7SbVZEz8F3fmfUlu7fz+dQL4Bmh0Z8
         Ghl5N4G4PivWqqU6lUgfgQTCke4lu2kRMzjZyggxjyC4zAgwwn0A5pzSQKhCyfdmxeib
         VXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QvHRlN/FiOE37BimGmhAJvTh/MyrPZOwXFm2koNz7uA=;
        b=mZRy7cVC1yvlAZIeGArek0S/Yy3eDzDH695UPQyReTHMtHrIPGt3ZZPJFm8kRt2JT1
         vW6pdJn0ukaTjU4n+ywr1nASR/mDA3xZui8lzHGdmKx2rDFVToJfWOMDrT1y0yyuMEr4
         bkAeavy6ZZXe91pIzCEIUbBMLstvlBOYBoJvGv3do9fYD5fce5C+7g42zKl4N3Azh0mW
         pU3fuGAjoysTFQZF5osj5KklqqgSQMDx4StxDc80IohZLeoUDXDE555BjAoUEFp9ObOE
         6a+jWFhUJOp1VOIQ7CdD58bNHaLG2T0/HcIefi83995RA6dJSCm+l434dWzUHK0Ms53m
         7+GQ==
X-Gm-Message-State: AOAM531QJ3dY2to1iYx7luThVzo1I0SorEOMFUFAf0v6MldSpwVGXIv/
        nnWtsKXvz/Nm19R4DMPuHO2YvHGUmy6VSw==
X-Google-Smtp-Source: ABdhPJzyEc4zuA5H+lgFK6dZ/tXKFs1LF8uaGUo+qO6MtR4RxoGm6QuX5xExqCIuXqFpNbBzvFrQYg==
X-Received: by 2002:aca:3b09:: with SMTP id i9mr4708719oia.92.1623793236490;
        Tue, 15 Jun 2021 14:40:36 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x187sm29470oia.17.2021.06.15.14.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:40:36 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: fix min types mismatch in table alloc
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>
References: <50f420a956bca070a43810d4a805293ed54f39d8.1623759527.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d3409bbe-2134-224f-b53c-1e74adad8ab4@kernel.dk>
Date:   Tue, 15 Jun 2021 15:40:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <50f420a956bca070a43810d4a805293ed54f39d8.1623759527.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 6:20 AM, Pavel Begunkov wrote:
> fs/io_uring.c: In function 'io_alloc_page_table':
> include/linux/minmax.h:20:28: warning: comparison of distinct pointer
> 	types lacks a cast
> 
> Cast everything to size_t using min_t.

Applied - didn't fold it in, it's just a warning.

-- 
Jens Axboe


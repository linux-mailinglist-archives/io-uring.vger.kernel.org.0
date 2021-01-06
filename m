Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AEB2EC104
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 17:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbhAFQV0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 11:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbhAFQVZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 11:21:25 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64073C061357
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 08:20:45 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id 75so3679682ilv.13
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 08:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HqfL9ZkT9w+M7/P4X+V/Xy4tOVJ86haU7KOu1523KOU=;
        b=dBtjKMtGonPCMzft3nbeSKai3CeFhhYHjLTVxEdTWU1zqtX+iVrIMklbW15wlOTB4n
         CuzwbzK+5YgEcJMZtqb7537V8hG4o4j/fBhwyPv5vlgfYrErRuXb+B7qZfkUEBZamSBE
         ijcdNkH3R5kR87yjP/9za1d9qTsNrRhObRvIWHEA+bi0qmJczPz0DUO2r2l1yUsH1S/c
         3QcCQEqSJbyXjcZJsXPiQMHx/KJuIPjedzqKKE0BfoKgDOS6O8H4fSX9WEN3/2qh63H0
         W8PSohgeSJLt3FudqlObDr9zzmolF++jLFDsAE37mSZxmiMLlDUvLOPoDd5AXR0DYL5O
         ahtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HqfL9ZkT9w+M7/P4X+V/Xy4tOVJ86haU7KOu1523KOU=;
        b=SYxBILX7xVKdvunOQ9+VfcBgAjvU9RjhejIIBhR2idTliGCGe8U057At9L6Y7EHxKF
         OCz0FLVlOU8AoOdMAfCNVnSxovDtpLJBvSIhTsPWR7dtCXjzNlLIp3UavzFPd99UjdOg
         YrgOmJdFeyFIySdg+lV4VHlfRDmWMPAgD1DiTZA+NBOvzgimSKzCKPf9tJGSgo8rXPEi
         uglUN8xrFoQ2aMhph6wefyeuBhn6FQSeHvWWDi6Mkc6lvYA/skzf8h8VcwR4IJVFtGQO
         G8rhPZZCxDp6Si7e9WnLHRugiLEptHBB9MUdbPW7B1t5mDwhR5XLOgM4ofoAsFMIemhp
         LsyQ==
X-Gm-Message-State: AOAM530UKi9ahfqnxjxaA5iheAhMFwyZp6btiwCKoBUTadQ5EtiTbCkb
        ua4HAhgIXxj9hh3OkwlXLFBw7A==
X-Google-Smtp-Source: ABdhPJxDOW8xbnSBA0Vd291qiX/hpnQNczmXKYTWejajTwJ4WpV1bd/JdUKlL7oD2krGoaly228zjQ==
X-Received: by 2002:a92:d10b:: with SMTP id a11mr4789688ilb.86.1609950044742;
        Wed, 06 Jan 2021 08:20:44 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q5sm2224023ilg.62.2021.01.06.08.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 08:20:44 -0800 (PST)
Subject: Re: [PATCH] io_uring: Fix return value from alloc_fixed_file_ref_node
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20210106160926.593770-1-willy@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7facda23-3c3d-473d-9ec6-c58cbc1ea6de@kernel.dk>
Date:   Wed, 6 Jan 2021 09:20:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210106160926.593770-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/6/21 9:09 AM, Matthew Wilcox (Oracle) wrote:
> alloc_fixed_file_ref_node() currently returns an ERR_PTR on failure.
> io_sqe_files_unregister() expects it to return NULL and since it can only
> return -ENOMEM, it makes more sense to change alloc_fixed_file_ref_node()
> to behave that way.

Applied, thanks.

-- 
Jens Axboe


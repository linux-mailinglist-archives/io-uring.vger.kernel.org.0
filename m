Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CF02ED3CD
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 16:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbhAGPyQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 10:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbhAGPyQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 10:54:16 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6BEC0612F4
        for <io-uring@vger.kernel.org>; Thu,  7 Jan 2021 07:53:36 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id q1so7163777ilt.6
        for <io-uring@vger.kernel.org>; Thu, 07 Jan 2021 07:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VAaFrn/MqfzLgjaRPyz995k3LBKVfuHPwIAsHv0IiSE=;
        b=N5LTaw0bqqZaAeB4nFbgdIAo6mtEj6AOWzU3b/PJj7yatl1Rw6eSpFcmh1bNKJInsU
         J0CJkokRNBBLCW2EN/A6Out5Cls//OIzvffc9DKyxLLjID/vefhxdnQ2g8Ec0Xu0eIPb
         gBgdeSymzTWwESqz4cGO8khTl9O5hepFz3ChfJ/yQPsfor2Wqbx7muKh+guqglrFwomu
         7so6b8zpRBdBJtFYsSH6JIhpdFuJe4vMJMjzPqgXSBM0EXmPJBmisW3fs7zOtJht4gpd
         pyOZ+rWDS05TQDjHgjpsZWySR6wr4/P23BuCQb2apFGm4PtOdoWdyKdhs8MCTHVZQ4Gz
         OAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VAaFrn/MqfzLgjaRPyz995k3LBKVfuHPwIAsHv0IiSE=;
        b=DALccLsiMjcbT+ixcY/GBzvz6I6kvhPlI4BMsI1UOPYEKBFD9RzdFhPB7MFrxdZVCF
         FJCGKSUV8U0bCpDCZkcw22IUJGaG3OCTsZihcLbl56HWEx73N5MAtOAJKtzqwZ0gsr4J
         isr0VUDqEIHdEy44AVxcdxcXa3NrTWUNgtjh/JWCuF7wL67IUhS9qfcRzwUhOh23XVQ7
         UzeH4MiFW6lS/9hEZ64hhu/Ai8PuidZ+uRidtW9HRIAUuTG7tc8RbqzFz4kmxOBi1jFu
         qvJYiQcJrI5NK7yN/u7Xb/iWDi/q3QS1Hdh3GufXrjqqbeW2srenuDwm3YFYhnzxPWT7
         6++A==
X-Gm-Message-State: AOAM532QzgSwwOmJKLuO0H2/grCOUxn+eY2LjlEVZU+93W7CT6LZD5XZ
        Ge25FiOUTT5h2qzSkcEWebvg0TDOUX/AlA==
X-Google-Smtp-Source: ABdhPJxE6wyWVBmKJx351aiYXu7XHnU/1n9+NFgflez4kp/rp6BVFemKebcpFuiD/uXvvCNNitAz6A==
X-Received: by 2002:a05:6e02:c25:: with SMTP id q5mr9374359ilg.286.1610034815108;
        Thu, 07 Jan 2021 07:53:35 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s4sm3725385ioc.33.2021.01.07.07.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 07:53:34 -0800 (PST)
Subject: Re: [PATCH v4 00/13] io_uring: buffer registration enhancements
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a6ca0151-b600-a57a-e50e-2e4f8aa3619f@kernel.dk>
Date:   Thu, 7 Jan 2021 08:53:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/6/21 1:39 PM, Bijan Mottahedeh wrote:
> v4:
> 
> - address v3 comments (TBD REGISTER_BUFFERS)
> - rebase
> 
> v3:
> 
> - batch file->rsrc renames into a signle patch when possible
> - fix other review changes from v2
> - fix checkpatch warnings
> 
> v2:
> 
> - drop readv/writev with fixed buffers patch
> - handle ref_nodes both both files/buffers with a single ref_list
> - make file/buffer handling more unified
> 
> This patchset implements a set of enhancements to buffer registration
> consistent with existing file registration functionality:
> 
> - buffer registration updates		IORING_REGISTER_BUFFERS_UPDATE
> 					IORING_OP_BUFFERS_UPDATE
> 
> - buffer registration sharing		IORING_SETUP_SHARE_BUF
> 					IORING_SETUP_ATTACH_BUF
> 
> I have kept the original patchset unchanged for the most part to
> facilitate reviewing and so this set adds a number of additional patches
> mostly making file/buffer handling more unified.
> 
> Patch 1-2 modularize existing buffer registration code.

Applied 1-2 for now with Pavel's review, hopefully we can crank through
the rest of the series and target 5.12.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543CB2EB2AD
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 19:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbhAESfV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jan 2021 13:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729768AbhAESfU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jan 2021 13:35:20 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F777C061793
        for <io-uring@vger.kernel.org>; Tue,  5 Jan 2021 10:34:39 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id q5so586411ilc.10
        for <io-uring@vger.kernel.org>; Tue, 05 Jan 2021 10:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IA49EGolIR139GnqcS9SG7ZscrYFL03qebRLyr6e/b8=;
        b=EStAmOJa9hJcTwid/i4LaQuTWaiC6NV18IK2LSiyuyq/D0fdBejFBwssC7oPEYvNSn
         tFKlO1ZqgiXq9HvU+ZENISJGOlez/PJdZa/QZfyGaJGkgULcHUZAPrFOVVdNIj2UH9UX
         2/mQgCF0Tu8LWYk7NXMlHZAga3F/BdP0ZYT9OQLG22s+cb411bnrY50pXHkA4L5aX6WK
         1/WdBYGftpOpSG0Y0epzDw/xdCDsG0pmn8lbsJ/cLW9+a1SGyBP8a3+RPN4ZtJIJxL2C
         4YPppBFk8gQ/z23tqD+HIL9kwRoYZJWvPvPVY6f7pZc+q6W+t6fgO0tHESHz0Y6WD4sE
         g1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IA49EGolIR139GnqcS9SG7ZscrYFL03qebRLyr6e/b8=;
        b=dAk8C7fkRv7v1mZxigpOcFb/MN62fI3d3lC2AMlTSgfM1VnA1Xx/iw/BGtfFhazLxt
         6LGurmoBnQ+lh6AK2SZPwFMhj3cqsjUTnGr+FVU/2eG431OvYTBWSsQRZjiizzNabZdO
         8hro0U2OkdTygAOblE65UDBcdKEPCNAGC7Ny8AuuY44H86kLdJZD1ZJp1C6uSnx2Qxso
         RPOFGToBrodCcF7fMTIcqmTrkZxdWn7IY/RdSFkclw9pHCc6/Z6UUIAqZGoBMUHpaFP6
         SJpeM0tmht/7iZOkqaHsZSJ6nnhKSKPUKNodvUtGwLDblZ/4xarUclXZGeBFMiR2Bd0N
         dfTg==
X-Gm-Message-State: AOAM532bs4Ff0peF67cMsPfM8gKRl6pOKUb8gezrf9gvIM+3bwsEIEuw
        5jf4cpNMOqIphdJyE2WQVvO/ow==
X-Google-Smtp-Source: ABdhPJxRTI4U5rL1enSlQ9gPeslkS+dPcaalPJGVtYzp05inGOuEwgfzu12ni0EMax7Q4BrEjezdiQ==
X-Received: by 2002:a05:6e02:1107:: with SMTP id u7mr912235ilk.15.1609871678795;
        Tue, 05 Jan 2021 10:34:38 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h18sm49068ioh.30.2021.01.05.10.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 10:34:38 -0800 (PST)
Subject: =?UTF-8?Q?Re=3a_=5bPATCH=5d_io=5furing=3a_Delete_useless_variable_?=
 =?UTF-8?B?4oCYaWTigJkgaW4gaW9fcHJlcF9hc3luY193b3Jr?=
To:     Ye Bin <yebin10@huawei.com>, viro@zeniv.linux.org.uk,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210105135340.51287-1-yebin10@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c4cb0ab4-d419-0ded-50c5-5af9f95746be@kernel.dk>
Date:   Tue, 5 Jan 2021 11:34:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210105135340.51287-1-yebin10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/5/21 6:53 AM, Ye Bin wrote:
> Fix follow warning:
> fs/io_uring.c:1523:22: warning: variable ‘id’ set but not used
> [-Wunused-but-set-variable]
>   struct io_identity *id;
>                         ^~

Applied, thanks.

-- 
Jens Axboe


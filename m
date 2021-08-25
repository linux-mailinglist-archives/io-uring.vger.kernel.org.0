Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1F33F77E9
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 17:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241920AbhHYPBE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 11:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241538AbhHYPBC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 11:01:02 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C994C06179A
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 08:00:15 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e186so31219880iof.12
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 08:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iLfJeET2ve0H5UgkAIjYFsr7rtgqOzhLAiJ9vDMCtuc=;
        b=CUXmdc1nbVcvgegRerTbifpZts7ufvUAqg4rpm1mItTX8pHSMRcRc9mmAXKW+yFIVM
         wY1pPZPsIBFqLl+UyJmlupEzWvSp/A4U4NtuNp14vqMeSV/KSvMBzpEb0OPyvOW7Fz2x
         7HROreHktuMu366P2mbOrYEcWK2d4g2Kg9fHMqKaRzX9zQXGM2NiGKbv+gRCuFDkWP4E
         PgKnP/ObMLO+orS3a4Q5jW0kSXGQ8FALoP/geajGrkfu3fS/lneoRgbBcZ9F/1cTkWkD
         NWNaF9Up9BLKGTzxwQ/zUB/8pzYNuRXM5FdKuUWaxucUhpe9mP8S/D6zPZNiTAP95uiG
         4aOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iLfJeET2ve0H5UgkAIjYFsr7rtgqOzhLAiJ9vDMCtuc=;
        b=EyRGTl2p3C4buQYq8ybO3azgQT8q5otARIke8evo8f1bTvWoxwTvbl3XAfBN11IS9U
         HcFBA5UDoEhDwQ3n5sJ4eSYyR+0RG07oY3KS8bDwb+YL997dC70M79jKOVyatoEd9gAs
         hkmph6DUGMh4Cx2CPHEXgFFcYQSNABDiZepXPRBL0do+b1NSA2cDCp+KHomAdpaaHmLb
         PCr94hjTDO8Sr1I0FdLgqXTOnd16tIvyz8lDZEOvRzySa6tjbZNgV0dxnrI8ug2tbesf
         Le3WcNLUL4I+hCbNr5FyQr/firQX542yzIlMmamct8KM8r2xLOQtzXtbYxmme894mTOB
         qG3A==
X-Gm-Message-State: AOAM53080x8GkU6w0pCjxbXWkKZJ7CKJ0uyNWPkF42SAOc45oE8Tjw+D
        gcZK/ZVyOL9k1eD9du+911tniw==
X-Google-Smtp-Source: ABdhPJxowRvu6BIeDfSetidf16jz/ifyPgByV7bD5kDRnJANvWVMae8HWHHtySbzPxdwPBKI0tu1kw==
X-Received: by 2002:a05:6602:2436:: with SMTP id g22mr36663718iob.109.1629903613651;
        Wed, 25 Aug 2021 08:00:13 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f9sm110864ilk.56.2021.08.25.08.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 08:00:12 -0700 (PDT)
Subject: Re: [PATCH v4 0/4] open/accept directly into io_uring fixed file
 table
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1629888991.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <230278aa-9774-e31f-b4f9-c1785a2ecfc5@kernel.dk>
Date:   Wed, 25 Aug 2021 09:00:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629888991.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/21 5:25 AM, Pavel Begunkov wrote:
> Add an optional feature to open/accept directly into io_uring's fixed
> file table bypassing the normal file table. Same behaviour if as the
> snippet below, but in one operation:
> 
> sqe = io_uring_[open|accept]_prep();
> io_uring_submit(sqe);
> // ... once we get a CQE back
> io_uring_register_files_update(uring_idx, (fd = cqe->res));
> close((fd = cqe->res));
> 
> The idea is old, and was brough up and implemented a year ago by
> Josh Triplett, though haven't sought the light.
> 
> The behaviour is controlled by setting sqe->file_index, where 0 implies
> the old behaviour using normal file tables. If non-zero value is
> specified, then it will behave as described and place the file into a
> fixed file slot sqe->file_index - 1. A file table should be already
> created, the slot should be valid and empty, otherwise the operation
> will fail.
> 
> note: IOSQE_FIXED_FILE can't be used as a mode switch, because accept
> takes a file, and it already uses the flag with a different meaning.

Updated the tree and picked you davem's ack as well.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5BD2B8033
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 16:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgKRPPw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 10:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgKRPPv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 10:15:51 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12B0C0613D4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 07:15:51 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 10so1609358pfp.5
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 07:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=E+EuxLUyTZu9ZxlCmvWfUmHuJbO5Efo+cAXXJRc1FIU=;
        b=LaOj1AElo0KG11pLzmne3JL90rD5L1XbI+RexYEr0msJ9+x2uiVU/uYSUI/WLbkxCY
         mv4yejy1XHZWB4ERf0MEoegeNzgHIF4cQVlqWsR/it9wxO6nlA2bxMNsJGO+47HyVFsJ
         7fonUK50aZyhPv8unHjjd1JPyW0spmka6cAadiBJWeAqRPlyIH2aHk81GqkpmLSZGNmA
         Vy7oVRWGVwiOjptD2w305cMuU6odJJ7tqhWVL6tpnHQmUQDMdNf9u/Kp1a9dudMGxqBs
         aNsNozfVnkvRu2jTEwRDfzO+OOKgaqFQBZLvDmMIighliq25D6vprwVHgBQ1SKc5uYxi
         Pz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E+EuxLUyTZu9ZxlCmvWfUmHuJbO5Efo+cAXXJRc1FIU=;
        b=PxLI6eRKVCl7Cnk0rcnzBSKd9tJhV05AWypcNC1MomURNJOuVWIRt3xDROPnYpJs4g
         CPdsh1SiSVYfTPiJvk0bF/4eeazF9HP/mFUxjDJQrll0Oq6MvADKPLl6TmrgUcthuTmQ
         iDH/hH15QQupi8PN74bqKU+/tvSqSysRBCyfGs1npB8FZOhGIfhybUuzixOCM0TccTjo
         /JiwMmnyPucZsIqPIkedXrKoUwjlOYY5qXgCsKXvwuQH8aAziJeiaLZTjtfLA0HW3mn6
         rs9BhkUm5qQymQpfo7r5YuLq1aVJG4W06Hd/8bbVSo1zXOIzOViEFTf6HCjffxDTbacT
         0Wig==
X-Gm-Message-State: AOAM533xkKdVrjGDpTNOhqBjmdpcXece8EBZxGF6x76Y0EzcpjatXLPg
        2Fr1HvsJV14yExqV+ao04cSaQmFE9O8XDQ==
X-Google-Smtp-Source: ABdhPJy75kNjZVcGNIyfkhnYlFA9hTYTs3722SzsZqvE9i43S+khJJPXX3uW7UiZrvzgsgyLVp81Tg==
X-Received: by 2002:a65:4945:: with SMTP id q5mr8202492pgs.83.1605712551161;
        Wed, 18 Nov 2020 07:15:51 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 143sm16505236pgh.57.2020.11.18.07.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 07:15:50 -0800 (PST)
Subject: Re: [PATCH 5.10 0/2] order fixed files refnode recycling
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1605710178.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <986c720e-65ce-0343-a410-c1ae8b53067e@kernel.dk>
Date:   Wed, 18 Nov 2020 08:15:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1605710178.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/18/20 7:56 AM, Pavel Begunkov wrote:
> Pavel Begunkov (2):
>   io_uring: get an active ref_node from files_data
>   io_uring: order refnode recycling
> 
>  fs/io_uring.c | 37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)

LGTM, thanks Pavel.

-- 
Jens Axboe


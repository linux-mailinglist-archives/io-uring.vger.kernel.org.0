Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EF7144579
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2020 20:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgAUTzW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 14:55:22 -0500
Received: from mail-io1-f50.google.com ([209.85.166.50]:35688 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgAUTzV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 14:55:21 -0500
Received: by mail-io1-f50.google.com with SMTP id h8so4170543iob.2
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 11:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QxVnMIkm8w27QudQa9DYhjTg91qD53gtsSN+RQ6U+Vc=;
        b=KP6j6WmoEskfGs0lHXwnVSzV+wRAN3pGzkoCgOOPu/jEmyt38FON8lrkMhW9RhmKZ+
         hba+Gk7O4kv4QKL925WsbL7WK8Gr+Uk/acGeesTP1KsNe3TftGij/c+KCWvB/5yrEIb9
         /3P0fjL62ySTzy827LEPbaZ/csfJiH0lIpQtG41+HINA8ImFeuMVv3fnCnYVfO19y6MN
         7+RBRfQSwZnu5JhTyy6u46iIK8/cml7zfDRI8wmCm98ebf/KOR22AOADExuFA29PTVWC
         Diup0H4ElPVRThdmRG/mHTXYB/fw1Gzzo4UKS9e1dr8hpZltXQUqN9IqOERZjIqg+dxW
         3XKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QxVnMIkm8w27QudQa9DYhjTg91qD53gtsSN+RQ6U+Vc=;
        b=KoZC5XkCNCp1NXqBlzya+QxnDp+YU+/CgnaRKNhuiPvifGaFCst3PJkOchIxqOdu1U
         pQ+naDHzKr+EDANj10bDSqys8DOLtNfzQRTo9BzW8HPLvn/zrJy4oI71H0H0hr3g/wNR
         ve9v/tj7CG8GT0tT/9TLb7qMB8L4sn5FqfK/Mm0sUtGV/c8CAgspyKX9Qdu5rK45HBTt
         9UOipKEDL4a6baIA5FE+EkSdD5/ufC2//UrrS2Mhmwq5ApBnjFRHYB3FfOd6egYQ5NLg
         8tNVisB3R1KEEqEgQ6Q9cTgsAfU4Udo9dK1LuvjU8SqKAI+FVvqH0mv8W+7+M9sOZ7ge
         kgfw==
X-Gm-Message-State: APjAAAW1BaucE2zTMeDsWuJyrJcvsAxaElFsvYZSY7B8DHrHWWU/PUd4
        Yb39PE2v3KZHuGyTtwy9nhpbNwXfEqU=
X-Google-Smtp-Source: APXvYqx+DyNs2UDGW+eMIYx01CQPwBv2iaEv7D3CDP54NRCrKPn47Nfvs9Y+1eV2F+3JyITaKGPXNQ==
X-Received: by 2002:a02:9462:: with SMTP id a89mr91395jai.89.1579636520773;
        Tue, 21 Jan 2020 11:55:20 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g6sm9887914iob.88.2020.01.21.11.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 11:55:20 -0800 (PST)
Subject: Re: Extending the functionality of some SQE OPs
To:     Mark Papadakis <markuspapadakis@icloud.com>,
        io-uring <io-uring@vger.kernel.org>
References: <30608E23-1CE9-4830-BC95-8D57BCB4CCE8@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8ebf0463-34a2-3416-d7e8-a2be420b1b82@kernel.dk>
Date:   Tue, 21 Jan 2020 12:55:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <30608E23-1CE9-4830-BC95-8D57BCB4CCE8@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/21/20 12:50 AM, Mark Papadakis wrote:
> Would it make sense to extend the semantics of some OPS of specific
> syscalls to, for example, return in the CQE more than just an int
> (matching the semantics of the specific syscall they represent)?  For
> example, the respective OP for accept/accept4 returns an int for error
> or the fd of the accepted connection’s socket FD. But, given the
> clean-room implementation of io_uring, this may be a good opportunity
> to expand on it. Maybe there should be another field in the CQEs e.g
>
> union {
> 	int i32;
> 	uint64_t u64;
> 	// whatever makes sense
> } ret_ex;
>
> Where the implementation of some OPs would access and set accordingly.
> For example, the OP for accept could set ret_ex.i32 to 1 if there are
> more outstanding FDs to be dequeued from the accepted connections
> queue, so that the application should accept again thereby draining it
> - as opposed to being woken up multiple times to do so. Other OPs may
> take advantage of this for other reasons.
> 
> Maybe it doesn’t make as much sense as I think it does, but if
> anything, it could become very useful down the road, once more
> syscalls(even OPs that are entirely new are not otherwise represent
> existing syscalls?) are implemented(invented?). 

Would certainly be possible, I'd suggest using a union around cqe->flags
for that. The flags are unused as-of now, so we could introduce a way to
know if we're passing back flags or u32 worth of data instead. If we
unionize res2 with flags and reserve the upper bit of flags to say
"flags are valid" or something like that, then we get 31 bits of int
that could be used to pass back extra information.

-- 
Jens Axboe


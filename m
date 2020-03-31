Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A221998F0
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 16:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgCaOt5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Mar 2020 10:49:57 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36285 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgCaOt4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 10:49:56 -0400
Received: by mail-io1-f65.google.com with SMTP id n10so7916762iom.3
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2020 07:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NlR70/fLPGHkyu2nTtUgBov6RKNM5Db0ou2KiyEelLI=;
        b=oC5ziPpXlegZ9uHHnxCp2pimqgAjZbzo9vdfe05A97VpPHngTfI7wbFG0HbP4DbWxM
         LC/wz5w8KveQsVHZHJs9EDrNVLQNuIkgSxOs/9V0zhYTgivEmYabmn73ZtKSOBjzNwoq
         TyFm69gJugRvRuXM/fyCN75XdPxCwmGV4lywJo3IrXD1EAIxO4B1g6Qa4Df92XlK1jPs
         WS0sHlXSDXQ61ZoLVcZb9E6o9st5TZQMbj0SQKb3rGRD8ZGn5adX4nQuwQxH1aEpn8K4
         nlD26hb/adrEuQQHov8KKSxU42pBrWKVKxCUzFsJBVN0UzDpaYJ2Gfj0nQa0dBFZC9nl
         8nVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NlR70/fLPGHkyu2nTtUgBov6RKNM5Db0ou2KiyEelLI=;
        b=YUVYdGRd1rGZ8UUqxuxpLew1Zm1S2HRZvznmjSt7fV7nQB9e3U2VB31Ru71avZ/I9h
         B3M98XgAe8MnOczNYIArrOvo95Ef1MZLKhs9/Wka2uyJn2Aywe8xolX4F/pEFDf8QIhM
         0sIvNKtRNqtdzUm7Y+NMoTRVPA+dgfDzW6UGJxuAyB15mwIFRtcTODrmBlFYvnz/0oVd
         N4SXTLgqvC6NqAaOuI19nDv8Nbo8emYpp3LbtgRp4+NwWf1HHfSUhY7pI7cfuV/owSUv
         Pvxnssdy16C0aN2e3wzsk4ZO+MSywSnMPNQn0C9mX7FKtppaI/EbNkmxbXBBR+T/qNt9
         j8gw==
X-Gm-Message-State: ANhLgQ24LJcWYree1izQAIXlsWosftIOPSkLjZzm2XkJUXpX4HK7Kxk7
        sVjNzAeygnR31krlt2RKC8qtZ1kkh1363g==
X-Google-Smtp-Source: ADFU+vtrg9aXnrSIrucmURrav957d4Mg6OymLLZxYhBsep//O42XyF7GThVgGG44auFaflMMh7hKFA==
X-Received: by 2002:a05:6638:3a4:: with SMTP id z4mr16278730jap.141.1585666194537;
        Tue, 31 Mar 2020 07:49:54 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y1sm5027536ioq.47.2020.03.31.07.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 07:49:53 -0700 (PDT)
Subject: Re: [PATCH v3] io_uring: refactor file register/unregister/update
 codes
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200331060518.15324-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <403808f4-1bc8-9f02-0fdd-53c155fb1f73@kernel.dk>
Date:   Tue, 31 Mar 2020 08:49:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200331060518.15324-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/31/20 12:05 AM, Xiaoguang Wang wrote:
> While diving into iouring fileset resigster/unregister/update codes,
> we found one bug in fileset update codes. Iouring fileset update codes
> use a percpu_ref variable to check whether can put previous registered
> file, only when the refcnt of the perfcpu_ref variable reachs zero, can
> we safely put these files, but this do not work well. If applications
> always issue requests continually, this perfcpu_ref will never have an
> chance to reach zero, and it'll always be in atomic mode, also will
> defeat the gains introduced by fileset register/unresiger/update feature,
> which are used to reduce the atomic operation overhead of fput/fget.
> 
> To fix this issue, while applications do IORING_REGISTER_FILES or
> IORING_REGISTER_FILES_UPDATE operations, we allocate a new percpu_ref
> and kill the old percpu_ref, new requests will use the new percpu_ref.
> Once all previous old requests complete, old percpu_refs will be dropped
> and registered files will be put safely.

Looks good to me! This is a nice improvement, applied for 5.7. Thanks.

-- 
Jens Axboe


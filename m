Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561123AECEA
	for <lists+io-uring@lfdr.de>; Mon, 21 Jun 2021 17:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhFUQAF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Jun 2021 12:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhFUQAF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Jun 2021 12:00:05 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE8BC061574
        for <io-uring@vger.kernel.org>; Mon, 21 Jun 2021 08:57:50 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id d9so7526049ioo.2
        for <io-uring@vger.kernel.org>; Mon, 21 Jun 2021 08:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jVYdu/JHdD3DwhMqrGzbw0N2BmX7zM9L4IBZN/tXq4k=;
        b=lJmqJkiPNEyFyPAbp4D6y1VBZuqm5pleBw65Z/IGXbZACmJQN2qTHhchdJ1nCrRhAn
         69j4SK0Apv1hr2shIUyGbQTIr/9PBNRkSO4rf/hJ2UJJVHOFcJsElRJUAeUWFIoomHDA
         EFtDPQHf3FBomAyrBXS0vuIz6JXwK2ykLos79JpxwiDD4IjZjFjJ+uEGw2t6MZLZ5zJZ
         2hzPjNp53k9UOltyJQ0nzOg8wt6I+q7W3NXaU+qAjFHZO88wvHZKlHr1+53YrAgY9K5A
         91NvYc4A4Lb2wC6fWojD8xd76ZOmM1ctcMDN2rpjbHDYovTDXzbbuUGwxilierulMgVS
         E19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jVYdu/JHdD3DwhMqrGzbw0N2BmX7zM9L4IBZN/tXq4k=;
        b=rjlI4Q9+yIgPbKL2Rkng1LHLNqr3oYuV39sts0d/jtF5LLf5mqi8jy4A1rR5YL+Gsl
         b57J3bcxr+PMlFqjfXlhOgMHQlZsSnk2CwnkzBePGmrSpvVbWIZSk2AV3sFn8hdT8U5e
         7TkJVB+SfXBRkxr+85XUqIfXVSiAnyP2nTqu6iuUJSRtTzDtP0wYqb3hi/N6ALFOKOB4
         aXtxF8lNdylcPmgL/EvEAnM+ZpnQOIEOiRkiX5P3Y9ZLPJuwSBfJy7sgjICpBN3pl13G
         jckl0PBWkAl1GfYRveeevRbv22UB39ndrg2kqM0Zrpw2Y3EwoVtOxoCuKn7aYheRUAq/
         3+gg==
X-Gm-Message-State: AOAM5300wVKChHOPqfpYm1TUl/0SMCsZ4jwaCSwxemdcA4k3METZfDhc
        xYzhGQTyPAjCdIx3+NreYcVWGVkuUvdtHA==
X-Google-Smtp-Source: ABdhPJxvN6WY08A8+Wl4gxpRvSZQltvzkxQ1N5q3tgRtCRHk0hc1Ehwp44qxs0Em0S+iy45zRwlRig==
X-Received: by 2002:a5d:9f07:: with SMTP id q7mr19701533iot.169.1624291070033;
        Mon, 21 Jun 2021 08:57:50 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l11sm6343017ilo.77.2021.06.21.08.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 08:57:49 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat
 support
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b6ab44fc-385f-6f96-379d-ce6cbabd7238@kernel.dk>
Date:   Mon, 21 Jun 2021 09:57:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/2/21 11:18 PM, Dmitry Kadashev wrote:
> This started out as an attempt to add mkdirat support to io_uring which
> is heavily based on renameat() / unlinkat() support.
> 
> During the review process more operations were added (linkat, symlinkat,
> mknodat) mainly to keep things uniform internally (in namei.c), and
> with things changed in namei.c adding support for these operations to
> io_uring is trivial, so that was done too. See
> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> 
> The first patch is preparation with no functional changes, makes
> do_mkdirat accept struct filename pointer rather than the user string.
> 
> The second one leverages that to implement mkdirat in io_uring.
> 
> 3-6 just convert other similar do_* functions in namei.c to accept
> struct filename, for uniformity with do_mkdirat, do_renameat and
> do_unlinkat. No functional changes there.
> 
> 7 changes do_* helpers in namei.c to return ints rather than some of
> them returning ints and some longs.
> 
> 8-10 add symlinkat, linkat and mknodat support to io_uring
> (correspondingly).
> 
> Based on for-5.14/io_uring.

Can you send in the liburing tests as well?

-- 
Jens Axboe


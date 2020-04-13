Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D89E1A6513
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 12:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgDMKOm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 06:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726552AbgDMKOl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 06:14:41 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2020 06:14:41 EDT
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A7FC008748
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 03:09:40 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id m8so8184997lji.1
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 03:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=un7irJoedpqInAOSgOEqwPCggdwSKlRDUUuIS6vPijE=;
        b=NQrvstNAB9BANJbXTIOy9w8YaOER3Kj11olTAMbgDZnfEHJePlRynNxQ5PH4OISAER
         KxPuccdluL8IAQwTl0L0KtOF5nHKbxXGWd3+Yd9YgqMzKD9LejPu7Mv61q2udWtkrrFG
         HNsIsHARk6g/xefhTczagpZUbQypQaKH7FWqHIv+4fn5vqs5CriY3ThQDtPTN2phNZeM
         pBGCwurkGodDuPDxdPC7pcWAxHUhQ0pOHghBlYWH2hPiXx4Rae6Jp65gQpXsoGpzQX/e
         ctcMhnuvnwwV6MOycFL8DWQXSn8CZXcAX8mc+0VKnMckO7syThn14KB0TvPz86EPtXDk
         xrEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=un7irJoedpqInAOSgOEqwPCggdwSKlRDUUuIS6vPijE=;
        b=Hak13CNUrhN4rKSe0dHPveaIQfLeHdw+GugNrr9erBNpmkr+OI8+k8VL7tbduScEbL
         XvMhKQdbnH4YNqQhawQvimpV9VM/4IPIQGFeSNlyG5c1wQfJfSlAhjHbZqTtbvZKysI2
         cZXcBE6xbxdzcMxq0wuQtCIlJoCR0hMGtWLVNPgY7UlbijfyZ3GaLrMFVVka5FeB5jIO
         bRvAhrO/x9/TFyMmgPX0I5A4YDNQUxYqQrmc6E6Lx7DGOCOWgzrL5Z3ySeG8Fg+gNxKa
         ujc4CeGOD5i5RKVGIc1/uEqTm3rGsmBbqHkYDSNCMBXUfV5OmRLzSpt2VBfW3Qd1a2Iw
         Njhw==
X-Gm-Message-State: AGi0PuZZJeSJ87Y1lYtJVfRYhmvYDzpncIV2mOF9sa+ZpfsiEmkbFLFr
        etAXIy8f8xYI317dRdS2k8VItErA
X-Google-Smtp-Source: APiQypJq/BrBtNGoBzMEzoIduByoLSoXW49D0Mwty+eiGdCqraq9PRVzhorgV7MZJlmxYP/LUKQ6fQ==
X-Received: by 2002:a2e:909a:: with SMTP id l26mr10151217ljg.177.1586772578962;
        Mon, 13 Apr 2020 03:09:38 -0700 (PDT)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id h9sm4257270lji.30.2020.04.13.03.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 03:09:38 -0700 (PDT)
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Dmitry Kadashev <dkadashev@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk>
 <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
 <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk>
 <CAOKbgA4xX60X+SCMZFL76u86Nyi0Gfe25BGJaqR700+-zw72Xw@mail.gmail.com>
 <47ce7e4b-42d9-326d-f15e-8273a7edda7a@kernel.dk>
 <CAOKbgA5BKLNMzam+tDCTames0=LwJmSX-_s=dwceAq-kcvwF6g@mail.gmail.com>
 <7e3a9783-c124-4672-aab1-6ae7ce409887@kernel.dk>
 <CAOKbgA7KYWE485vAY2iLOjb4Ve-yLCTsTADqce-77a0CQxnszg@mail.gmail.com>
 <d55af7f3-711b-23b9-2ea3-00d600731453@kernel.dk>
 <CAOKbgA6JN4oQzyUo0_2y2KUKGX_xuwmDnQsCCABPq_nxms12Aw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <bba27d9d-db8c-f916-5f56-5583ba56591b@gmail.com>
Date:   Mon, 13 Apr 2020 13:09:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA6JN4oQzyUo0_2y2KUKGX_xuwmDnQsCCABPq_nxms12Aw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/13/2020 12:20 PM, Dmitry Kadashev wrote> Can I ask if this is going
to be merged into 5.6? Since it's a bug
> (important enough from my perspective) in existing logic. Thanks.

Yes, it's marked for 5.6

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC21156097
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 22:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgBGVO0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 16:14:26 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:38756 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgBGVO0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 16:14:26 -0500
Received: by mail-pj1-f47.google.com with SMTP id j17so1440865pjz.3
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 13:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QDgzuvS14UCHqjHsGlZ0Bs3sxum9KYO9NF1VlLb7kg4=;
        b=0QGtUiDm9fq86BNHtRqDZy3OlYFf1JSG1007YKrSvkQrVbbxz8sGsgtg0Z5CGstZJc
         Zf/8JxiKWi+nvFAn25ME0LPyo1xfG3D0zfkkABoHZdWDxIXFUtdwdBiMZPNk81eKrWfb
         QiyQpE6dRPijWNTilUpqnmipJBdn6Ca2Q3CazpGTy18Kl5pV8RZ4k4+7SXancb3wBfP/
         LQK81JjjOJiWge4SB9fURyR3xGEbIACiyMN+mNOV8DxltSDM3hqTMXowUV0lSbzOy5gx
         cm6zLSXjm4oflkM1pYZGu6cgGlKEVx1LfY7NbDoXiJ/QFbfaQUhA3DUSh+tGiebauI/o
         5TWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QDgzuvS14UCHqjHsGlZ0Bs3sxum9KYO9NF1VlLb7kg4=;
        b=geActrV5IwM7lzl92K7jbDrW81jGI4d9y3FWQfiaRiYuPb1xm4IWysUCnp7CC3RuCy
         OfZc6LXZkpE1AqjvfoisbMzKXOo8htzhtmXT96NtXJ+tknGAZ/kIpF4dRs9fvDhifRKu
         BfhzU9maHDfWcqh7pL0Rd3yDnoapXGagdpOHG95EZouzzecOygwdVCRhZN31vSSoMCJz
         b4hr4G+JGrY8yopGlihOBKumJ21pVm1EsRpVbgOWHZsoFg3enFp/2wCA6MhIWgkt7jsj
         duLKomopkLB5OjJd+28/Ev7e9fNp8aPcYOZ54IX8rHr+7MjQ/I1yxKmqiksIGRyaJSfN
         bk9A==
X-Gm-Message-State: APjAAAX3bNPQcDJ7rFH/2Faq/dfYzBSsXDA+12xJBWLovnoRl+s6xv62
        c2o6Fw3ireX+wqp9Q0vLUWOj3ktdhrM=
X-Google-Smtp-Source: APXvYqz9QmQaDjcOTlY61yq52N0Cxd535Rp9N6IuH+MVYg6G03p5qLfr0I5TtP23lOuybwVGMn797w==
X-Received: by 2002:a17:902:8d91:: with SMTP id v17mr296797plo.53.1581110064466;
        Fri, 07 Feb 2020 13:14:24 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::134e? ([2620:10d:c090:180::3860])
        by smtp.gmail.com with ESMTPSA id q15sm3908674pgm.47.2020.02.07.13.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 13:14:24 -0800 (PST)
Subject: Re: io_close()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <45f22c50-1ffe-4b73-f213-08dd49233597@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6052650b-4deb-4a4c-8efb-a85e4781cce2@kernel.dk>
Date:   Fri, 7 Feb 2020 14:14:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <45f22c50-1ffe-4b73-f213-08dd49233597@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/20 1:52 PM, Pavel Begunkov wrote:
> Hi,
> 
> I noticed, that io_close() is broken for some use cases, and was thinking about
> the best way to fix it. Is fput(req->close.put_file) really need to be done in
> wq? It seems, fput_many() implementation just calls schedule_delayed_work(), so
> it's already delayed.

It's not the fput(), it's the f_op->flush().

-- 
Jens Axboe


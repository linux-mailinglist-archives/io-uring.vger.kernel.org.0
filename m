Return-Path: <io-uring+bounces-9358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 094FAB39037
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 02:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 138247A3531
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 00:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D241A3178;
	Thu, 28 Aug 2025 00:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGKDi6fw"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC5926AE4
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 00:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756342116; cv=none; b=n6pjr9/qdhW5T1mgnAU1m6qVfumf0g5S53WcMBhXpf6MAy7pSB2ZzbjEuUBq6Bl5Vy4SegpMDTtndFF784Q90vDw+ZzsFFNp8qS2U+7qBOn8+LeF8PA81BRQ23X2CNLQC7D01AktbMA3azFq/8hoMgi+J7vQq6RwTnWikkvH00U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756342116; c=relaxed/simple;
	bh=jPOIqbaX5otSp3WzbbT+2/pxImfuTWJ2OFYKS4TvNE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKez6G32+WovV2AHsExxwLwYUm28Inw+3K5fPwbqVPzLTZzuQO5DlarYaphrMqbGvTnHVYz0fKgaocWRVEEDWCfzsnBB7CiGctePH3+PbcdNv6Irmj/kvKagzvGl8RVZM1YS1xovi+yzdefk0hBf6VioSnXarh3StnwxEhU7kn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KGKDi6fw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756342113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NH9M6qZ2J3KuMglksIXSkpXqc4X5PSXSXDDN9tN7Sr0=;
	b=KGKDi6fwuAksl3fOcwn5hijBc3wshfnJftJSyd3msl/9WNgzoJelMuXIYGeruUNKx4M6f4
	DkPHOYNI5M9AxwszUU+J2FPvihJ1FDI7g3BVd57nnjArbOZfe++Zg7dKMx8Ync8zph+EeT
	BNGjAJLY82WpHwHKy2VDz5Kqp5h5DY8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417-CQAOlXZZMKejLbKb2rtedw-1; Wed,
 27 Aug 2025 20:48:30 -0400
X-MC-Unique: CQAOlXZZMKejLbKb2rtedw-1
X-Mimecast-MFC-AGG-ID: CQAOlXZZMKejLbKb2rtedw_1756342108
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C46591956087;
	Thu, 28 Aug 2025 00:48:27 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B89B180028A;
	Thu, 28 Aug 2025 00:48:20 +0000 (UTC)
Date: Thu, 28 Aug 2025 08:48:16 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v3 5/5] samples: rust: Add `uring_cmd` example to
 `rust_misc_device`
Message-ID: <aK-nUJqy3HSTT71R@fedora>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-6-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822125555.8620-6-sidong.yang@furiosa.ai>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Fri, Aug 22, 2025 at 12:55:55PM +0000, Sidong Yang wrote:
> This patch extends the `rust_misc_device` sample to demonstrate how to
> use the `uring_cmd` interface for asynchronous device operations.
> 
> The new implementation handles two `uring_cmd` operations:
> 
> *   `RUST_MISC_DEV_URING_CMD_SET_VALUE`: Sets a value in the device.
> *   `RUST_MISC_DEV_URING_CMD_GET_VALUE`: Gets a value from the device.
> 
> To use this new functionality, users can submit `IORING_OP_URING_CMD`
> operations to the `rust_misc_device` character device.
> 
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>  samples/rust/rust_misc_device.rs | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/samples/rust/rust_misc_device.rs b/samples/rust/rust_misc_device.rs
> index e7ab77448f75..1f25d2b1f4d8 100644
> --- a/samples/rust/rust_misc_device.rs
> +++ b/samples/rust/rust_misc_device.rs
> @@ -101,6 +101,7 @@
>      c_str,
>      device::Device,
>      fs::File,
> +    io_uring::IoUringCmd,
>      ioctl::{_IO, _IOC_SIZE, _IOR, _IOW},
>      miscdevice::{MiscDevice, MiscDeviceOptions, MiscDeviceRegistration},
>      new_mutex,
> @@ -114,6 +115,9 @@
>  const RUST_MISC_DEV_GET_VALUE: u32 = _IOR::<i32>('|' as u32, 0x81);
>  const RUST_MISC_DEV_SET_VALUE: u32 = _IOW::<i32>('|' as u32, 0x82);
>  
> +const RUST_MISC_DEV_URING_CMD_SET_VALUE: u32 = _IOR::<i32>('|' as u32, 0x83);
> +const RUST_MISC_DEV_URING_CMD_GET_VALUE: u32 = _IOW::<i32>('|' as u32, 0x84);
> +
>  module! {
>      type: RustMiscDeviceModule,
>      name: "rust_misc_device",
> @@ -192,6 +196,29 @@ fn ioctl(me: Pin<&RustMiscDevice>, _file: &File, cmd: u32, arg: usize) -> Result
>  
>          Ok(0)
>      }
> +
> +    fn uring_cmd(
> +        me: Pin<&RustMiscDevice>,
> +        io_uring_cmd: Pin<&mut IoUringCmd>,
> +        _issue_flags: u32,
> +    ) -> Result<i32> {
> +        dev_info!(me.dev, "UringCmd Rust Misc Device Sample\n");
> +
> +        let cmd = io_uring_cmd.cmd_op();
> +        let addr: usize = io_uring_cmd.sqe().cmd_data()?;
> +        let user_ptr = UserPtr::from_addr(addr);
> +        let user_slice = UserSlice::new(user_ptr, 8);
> +
> +        match cmd {
> +            RUST_MISC_DEV_URING_CMD_SET_VALUE => me.set_value(user_slice.reader())?,
> +            RUST_MISC_DEV_URING_CMD_GET_VALUE => me.get_value(user_slice.writer())?,
> +            _ => {
> +                dev_err!(me.dev, "-> uring_cmd not recognised: {}\n", cmd);
> +                return Err(ENOTTY);
> +            }
> +        };
> +        Ok(0)
> +    }
>  }

I'd suggest to cover most of methods added in patch 2, so that any kernel
side change can be verified easily.


Thanks,
Ming


